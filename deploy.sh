#!/bin/bash

cd ./vpc
terraform init
terraform apply --auto-approve

cd -
cd ./eks
terraform init
terraform apply --auto-approve