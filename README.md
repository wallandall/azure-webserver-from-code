# Azure Infrastructure Operations : Deploying a scalable IaaS web server in Azure

### Introduction

This project demonstrates Packer and a Terraform templates to deploy a customizable and scalable web server in Azure.

### Getting Started

1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies

1. Create an [Azure Account](https://portal.azure.com)
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Policy

The tagging-policy.json file defines a policy that denies the creation of resources without tags.To create the policy run the below code from the same directory as the tagging-policy.json and tagging-policy-params file

1. az policy definition create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --rules .\tagging-policy.json --params tagging-policy-params.json --mode Indexed
2. az policy assignment create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --policy tagging-policy --params params.json  clear


### Output

**Your words here**
