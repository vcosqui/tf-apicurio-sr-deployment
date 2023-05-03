# Apicurio Schema Registry deployment

Provisions an Apicurio Registry server in Azure using Terraform

## Description
This Terraform project deploys a Docker image for Apicurio as an Azure Container Instance.
In order to assign an IP address to the container, the hosting network has to be configured with some specific delegations, 
so this project creates its own subnetwork on top of an existing network.

## Prerequisites
* A vnet network previously provisioned

## Instructions
1. Terraform plan
```shell
terraform plan -out main.tfplan
```
2. Terraform apply
```shell
terraform apply main.tfplan
```

## Testing
From any host in the same shared network try the following command replacing the ip address with 
Terraform "container_ipv4_address" output value
```shell
curl -vL 10.1.1.4:8080
```
