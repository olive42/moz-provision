# Introduction

This package automates setting up an EC2 instance that will clone the
https://github.com/olive42/moz-flask repo, and run the Flask demo.

# Prerequisites

* Terraform
* credentials on AWS, with an SSH keypair

# Running

Either set the following env vars:
*  TF_VAR_access_key (AWS access key)
*  TF_VAR_secret_key (AWS secret key)
*  TF_VAR_key_name (AWS ssh keypair name)

or put the following in a file named `override.tf`:
```
  variable "access_key" {
    default = "XXX"
  }
  variable "secret_key" {
    default = "XXX"
  }
  variable "key_name" {
    default = "XXX"
  }
```

Make sure to load the SSH key in your agent (ssh-add /path/to/key.pem)

Run `terraform apply`

# Output

The script will output the private and public IP addresses of the AWS
instance. The following command will connect to the app:

`curl http://$(terraform output public_ip)/`

# Cleanup

Run `terraform destroy`.
