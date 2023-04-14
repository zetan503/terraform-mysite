# Terraform MySite example

public ip -> ssh 22 -> jump host -> application host

# Usage

git clone https://github.com/zetan503/terraform-mysite.git
cd terraform-mysite

# AWS

## Create AWS Config

~/.aws/config

```
[profile mysite]
region = us-east-1
```

## AWS Creds

Export your AWS access key into the environment

```
export AWS_ACCESS_KEY=XXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYY
```

## AWS Login Test

```
aws sts get-caller-identity --profile mysite
aws s3 list --profile mysite
```

## Create a terraform state bucket

TODO Make not publicliy available

```
aws s3api create-bucket --bucket mysite-terraform-state-bucket --profile mysite
```

## Teraform state backend

Configure backend.tf to use your bucket name.

```
terraform {
  backend "s3" {
    bucket = "mysite-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```


# Terraform init

```
terraform init
```


# Terraform plan

```
terraform plan
```

# Terraform apply

```
terraformm apply
```

# Get SSH Key

Get the private key from the terraform state

```
terraform output ssh_private_key_pem > ~/.ssh/aws_private_key.rsa
chmod 0600 ~/.ssh/aws_private_key.rsa
```

# Use generated SSH config

```
cat ~/.ssh/aws_config 
Host jumphost
  Hostname 44.234.233.76
  User ubuntu
  IdentityFile ~/.ssh/aws_private_key.rsa
    
Host dvr
  Hostname 10.0.1.192
  User ubuntu
  IdentityFile ~/.ssh/aws_private_key.rsa
  ProxyJump jumphost


```

SSH to dvr will proxy the connection through the jump host using the generated key.

```
ssh dvr
```

