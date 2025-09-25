# 🚀 AWS EKS Cluster with Cilium and Addons

This project provisions a secure, scalable, and production-ready **Amazon EKS** (Elastic Kubernetes Service) cluster on AWS using **Terraform**. It includes:

* A custom-built **VPC**
* A fully configured **EKS Cluster**
* Networking powered by **Cilium CNI**
* Kubernetes **add-ons** like External DNS, Load Balancer Controller, and more

---

## 📁 Project Structure

```
.
├── deploy.sh        
├── eks/                     # EKS Terraform configuration
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
├── vpc/                     # VPC Terraform configuration
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
└── README.md
```

---

## 📷 Architecture Diagrams

### 🏗️ VPC Architecture

![VPC Architecture](https://github.com/user-attachments/assets/78c6ec61-ac1e-48b9-b1aa-4618871d130b)

---

### ☸️ EKS Cluster

![EKS Cluster](https://github.com/user-attachments/assets/bd8d4b6e-9e2f-4062-885a-ee74f99f63cf)

---

### 🧩 Cilium & Kubernetes Add-ons

![Addons Overview](https://github.com/user-attachments/assets/d65925f3-8267-4556-b92d-e1e35d2f012e)



