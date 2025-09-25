data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  endpoint_public_access                  = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = {
    Terraform = "true"
  }
}

resource "null_resource" "cilium_install" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${var.cluster_name}
      helm install cilium cilium/cilium --version 1.18.2 \
      --namespace kube-system \
      --set eni.enabled=true \
      --set ipam.mode=eni \
      --set egressMasqueradeInterfaces=eth+ \
      --set routingMode=native \
      --set kubeProxyReplacement=true \
      --set k8sServiceHost=${trimprefix(module.eks.cluster_endpoint , "https://")} \
      --set k8sServicePort=443
    EOT
  }
}

resource "aws_eks_addon" "coredns" {
  depends_on                  = [module.eks_managed_node_group]
  cluster_name                = module.eks.cluster_name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "PRESERVE"
}

module "eks_managed_node_group" {
  depends_on = [ null_resource.cilium_install ]
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "standard-nodes"
  cluster_name    = module.eks.cluster_name

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id]
  cluster_service_cidr = module.eks.cluster_service_cidr

  //  # Remote access cannot be specified with a launch template
  //  remote_access = {
  //    ec2_ssh_key               = module.key_pair.key_pair_name
  //    source_security_group_ids = [aws_security_group.remote_access.id]
  //  }

  min_size     = 1
  max_size     = 8
  desired_size = 3

  instance_types = ["t2.medium"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
