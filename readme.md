Alright, let's breakdown the repository you've provided and create a detailed documentation for it:

---

# Azure Bicep VM Deployment GitHub Action

This GitHub Action deploys a virtual machine (VM) in Azure using a custom Bicep module. The action leverages the power of Azure Bicep language and Azure Resource Manager (ARM) to simplify the deployment process of Azure resources.

## Table of Contents

- [Overview](#overview)
- [Usage](#usage)
- [Parameters](#parameters)
- [Workflow File Example](#workflow-file-example)
- [Templates](#templates)

## Overview

- **Name**: Azure Bicep Network & NSG Deploy
- **Description**: Deploys a network & NSG in Azure using custom bicep module

## Usage

1. Integrate this action into your GitHub repository.
2. Ensure you have the necessary secrets set up in your repository for Azure authentication.
3. Use this action in your workflow file, providing the necessary inputs.

## Parameters

Below are the input parameters required by this action:

| Parameter | Description | Required |
|-----------|-------------|----------|
| `azureClientId` | Azure Client ID | ✅ |
| `azureTenantId` | Azure Tenant ID | ✅ |
| `azureSubscriptionId` | Azure Subscription ID | ✅ |
| `environment` | Deployment environment (e.g., int, prod) | ✅ |
| `templateFile` | Bicep template file name (without extension) | ✅ |
| `location` | Deployment location (e.g., we, eastus) | ✅ |
| `resourceGroup` | Azure Resource Group for deployment | ✅ |

## Workflow File Example

```yaml
name: Validate & Deploy

on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]
  workflow_dispatch:

env:
  ENVIRONMENT: 'int'
  TEMPLATE_FILE: 'main'
  LOCATION: 'we'
  RESOURCE_GROUP: 'Test-Lab'

jobs:
  deploy:
    environment: int
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    - name: Deploy using Bicep
      uses: ./.github/actions/bicep-vm-deploy
      with:
        azureClientId: ${{ secrets.AZURE_CLIENT_ID }}
        azureTenantId: ${{ secrets.AZURE_TENANT_ID }}
        azureSubscriptionId: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        environment: 'int'
        templateFile: 'main'
        location: 'we'
        resourceGroup: 'Test-Lab'
```

## Templates

There are two main Bicep files:

1. **Bicep Parameters File (`parameters/int/main_we.bicepparams`)**:

    Contains parameters specific to the deployment, such as VM size, location, and OS specifications.

2. **Main Bicep File (`templates/main.bicep`)**:

    The primary template for deploying Azure resources. This file defines the resources to be deployed and their properties, leveraging the Bicep module for VMs.

---


## Deeper Dive into the Action Steps

### 1. Checkout

This step fetches the contents of the GitHub repository. This is essential as we need to access the Bicep templates and parameters for the deployment.

```yaml
- name: Checkout 
  uses: actions/checkout@v3
```

### 2. Azure Login

This step is responsible for authenticating the GitHub Action runner with Azure. It uses the credentials provided (client ID, tenant ID, and subscription ID) to establish a connection.

```yaml
- name: Azure Login
  uses: Azure/login@v1.4.6
  with:
    client-id: ${{ inputs.azureClientId }}
    tenant-id: ${{ inputs.azureTenantId }}
    subscription-id: ${{ inputs.azureSubscriptionId }}
```

### 3. GitVersioning

There are two steps related to GitVersion:

1. **Install GitVersion**: This step sets up GitVersion, which helps in versioning your deployments.

```yaml
- name: Install GitVersion
  uses: gittools/actions/gitversion/setup@v0
  with:
    versionSpec: '5.x'
```

2. **Determine Version**: This step determines the version using the Git history and the provided configuration file.

```yaml
- name: Determine Version
  id: gitversion
  uses: gittools/actions/gitversion/execute@v0
  with:
    useConfigFile: true
    configFilePath: ./gitversion.yml
```

### 4. Tagging the Repository

This step tags the repository with the version determined in the previous step. This is especially useful for tracking and managing different versions of your deployments.

```yaml
- name: tag the repo
  if: ${{ github.ref == 'refs/heads/master' }}
  shell: bash
  run: |
    git tag ${{ steps.gitversion.outputs.semVer }}
    git push origin ${{ steps.gitversion.outputs.semVer }}
```

### 5. Token Replacement

This step replaces certain tokens in the Bicep parameter files. Tokens are placeholders that will be replaced with actual values during the runtime of the action.

```yaml
- name: Replace tokens
  uses: cschleiden/replace-tokens@v1.2
  with:
    files: parameters/${{ inputs.environment }}/${{ inputs.templateFile }}_${{ inputs.location }}.bicepparam
```

### 6. Copying Templates and Parameters

Here, we create necessary directories and then copy the Bicep templates and parameters into specific paths. This ensures that the deployment files are available in a structured manner for subsequent steps.

```yaml
- name: Copy template
  ...
- name: Copy parameters
  ...
```

### 7. Artifact Publication

This step takes the copied templates and parameters, and uploads them as GitHub Artifacts. This allows for better traceability and post-deployment analysis.

```yaml
- name: Publish artifacts
  uses: actions/upload-artifact@v3
  ...
```

### 8. Adjusting File References

There are two steps here that adjust the references within the Bicep files. The correct path ensures that when the deployment action runs, it accesses the right templates and parameters.

```yaml
- name: Adjust using directive in parameters file
  ...
- name: Move files and update references
  ...
```

### 9. Azure Deployment

Finally, this step deploys the VM using the provided Bicep template and the parameter file to the specified Azure Resource Group.

```yaml
- name: Deploy using the artifact
  shell: bash    
  run: |
    az deployment group create --template-file ./main.bicep --parameters ./main_we.bicepparam --resource-group ${{ inputs.resourceGroup }}
```

---

## Bicep File Breakdown

1. **Bicep Parameters File**:
   - It uses the main Bicep template file as its reference.
   - It provides specific values for deployment such as VM details, location, and operating system specifications.

2. **Main Bicep File**:
   - This file defines which resources will be deployed and their properties.
   - The module `vmModule` is a custom Bicep module, hosted in a private Azure Container Registry. This module abstracts the complexity of VM deployment, making the main template concise.

---




you can use replace tokens to replace string that match the env vars from actions pipeline inside the anyfile

```bash
env:
  environment: prod

# in other file
param environment= '#{environment}'

```

action

```YAML
    - name: Replace tokens
      uses: cschleiden/replace-tokens@v1.2
      with:
        files: parameters/${{ inputs.environment }}/${{ inputs.templateFile }}_${{ inputs.location }}.bicepparam
```