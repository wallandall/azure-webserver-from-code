# 1. Azure Infrastructure Operations : Deploying a scalable IaaS web server in Azure

### 1.0.1. Introduction

This project demonstrates Packer and a Terraform templates to deploy a customizable and scalable web server in Azure.

### 1.0.2. Getting Started

1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### 1.0.3. Dependencies

1. Create an [Azure Account](https://portal.azure.com)
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### 1.0.4. Instruction
1. Create an Azure Policy: To restrict resource creation without tags, create a policy by running the below commands from the same directory as the tagging-policy.json, tagging-policy-params.json and params.json
   1. `az policy definition create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --rules tagging-policy.json --params tagging-policy-params.json --mode Indexed `
   2. `az policy assignment create --name tagging-policy --display-name "Deny Resource Creation Without Tags" --description "This policy will deney the creation of resources without tags" --policy tagging-policy --params params.json ` 
2. Create a Service Principle.
   1. Run the following command:` az ad sp create-for-rbac --role="Contributor" --name="TerraformSP"`
   2. The above command will output the below variables:
       - appId
       - displayName
       - name
       - password
       - tenant
   3. Create 3 environment variables with the values outputed above. These variables will be used in the packer template
      - ARM_CLIENT_ID = appId value
      - ARM_CLIENT_SECRET = password value
      - ARM_TENANT_ID = tenant value
   4. Run: ` az account list ` or get your Subscription ID from the Azure Portal
   5. Add the Subscription ID to an Environment Variable called ARM_SUBSCRIPTION_ID 
4. Create a Packer Image
   1. Ensure the variables in server.js file corresponds to the environment variables created in step 2
   2. Update server.json to reflect your information i.e.:
      -  "image_sku": "18.04-LTS"
      -  "location": "Germany North"
      -  "vm_size": "Standard_B1s"
   3. Create the packer image by running: `packer build server.json`
5. Deploy to Azure with Terraform  


### 1.0.5. Output

1. Output for Step 1 - Create an Azure Policy
   ![alt text](tagging-policy.png "Tagging Policy")
2. Output for Step 2
