Update the secrets.tfvars file with your account key and secret key.

# Terraform apply using secrets file to load variable
```terraform apply -var-file="secrets.tfvars"```

# Terraform destroy using secrets file to load variable
```terraform destroy -var-file="secrets.tfvars"```

# SSH into ec2 instance
```ssh -i ~/.ssh/id_rsa ec2-18-203-193-109.eu-west-1.compute.amazonaws.com```

# Sources:
* https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository