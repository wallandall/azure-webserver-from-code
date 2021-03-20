#  Azure Infrastructure Operations : Deploying a scalable IaaS web server in Azure

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

### Instruction
1. Create an Azure Policy: To restrict resource creation without tags, create a policy by running the below commands from the same directory as the tagging-policy.json, tagging-policy-params.json and params.json
   1. `az policy definition create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --rules tagging-policy.json --params tagging-policy-params.json --mode Indexed `
   2. `az policy assignment create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --policy tagging-policy --params params.json ` 
2. Create a resource group called packer-rg: 
   1. ` az group create --location germanywestcentral --name packer-rg `
   2. Ensure you replace the location with your location 
3. Create a Service Principle.
   1. Run the following command:` az ad sp create-for-rbac --role="Contributor" --name="TerraformSP"`
   2. The above command will output the below variables:
       - appId
       - displayName
       - name
       - password
       - tenant
   3. Create 3 environment variables with the values outputed above. These variables will be used in the packer template in step 3
      - ARM_CLIENT_ID = appId value
      - ARM_CLIENT_SECRET = password value
      - ARM_TENANT_ID = tenant value
   4. Run: ` az account list ` to get your Subscription ID or get your Subscription ID from the Azure Portal
   5. Add the Subscription ID to an Environment Variable called ARM_SUBSCRIPTION_ID 
4. Create a Packer Image
   1. Ensure the variables in server.js file corresponds to the environment variables created in step 2
   2. Update server.json to reflect your information i.e.:
      -  "image_sku": "18.04-LTS"
      -  "location": "germanywestcentral"
      -  "vm_size": "Standard_B1s"
   3. Create the packer image by running: `packer build server.json`
      1. If you did not create the environment variables as mentioned in step 3 or do not want to create an environment variable your can run `packer build -var 'key=value server.json` where key and value are the required variables.
5. Deploy to Azure with Terraform
   1. Review vars.tf to ensure the correct variables have been set. The default number of instances that will be created is 2, to changes this, update the variable "number_instance
   2. Run:
      1. `terraform init` 
      2. `terraform plan -out solution.plan`
      3. `terraform apply solution.plan`
   3. To destroy resources created by Terraform:  `terraform destroy`
   4. To destroy resources created by Packer: `az image delete -g packer-rg -n linux-packer-image`
   


### 1.0.5. Output

1. Output for Step 1 - Create an Azure Policy
   ![alt text](tagging-policy.png "Tagging Policy")
2. Output for Step 2 - Create Resource Group packer-rg
   ![alt text](create-group-packer-rg.png "packer-rg")
4. Output for Step 5 - Create a Packer Image
   ![alt text](packer-build.png "packer build server.json")
5. Output for Step 5 - Deploy to Azure
  ![alt text](terraform-apply.png "terraform apply")
