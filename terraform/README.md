# Terraform
This code will deploy:

- GKE Cluster

- Bastion Host (with access to GKE cluster)

- DNS Records

- Static IP Addresses

- Service Account (to be used by candidate on bastion host)

- IAM Policies for said service account

```
terraform init
terraform apply
```

