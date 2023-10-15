## Documentation: Validate & Deploy Bicep Template using GitHub Actions

This GitHub Actions workflow is designed to deploy infrastructure to Azure using the Bicep language. Here’s an overview of the steps involved:

### Overview:

1. **Event Triggers**:
   - This workflow is triggered when there's a push or a pull request to the master branch or if the workflow is manually dispatched.

2. **Environment Variables**:
   - The workflow uses environment variables to determine the environment (`int`), the Bicep template file (`main`), location (`we`), and the Azure Resource Group (`Test-Lab`) where the infrastructure will be deployed.

### Steps:

1. **Checkout**: 
   - This step clones the repository so the workflow can access its contents.
   
2. **Azure Login**:
   - Authenticate with Azure using service principal credentials stored as secrets.

3. **GitVersion**:
   - Install and execute GitVersion to determine the version of the code. This is based on your Git history and is used to version your infrastructure.

4. **Replace Tokens**:
   - Replace tokens in the Bicep parameters file. This step uses the `cschleiden/replace-tokens` action to replace tokens in the `.bicepparam` file based on the environment and location variables.

5. **Copy Bicep Templates and Parameters**:
   - The Bicep template and its associated parameter file are copied to a new artifact directory. This is done to isolate the files needed for deployment.

6. **Publish Artifacts**:
   - The created artifacts (Bicep templates and parameters) are uploaded using the `actions/upload-artifact` action.

7. **Adjust File Paths**:
   - Since Azure expects relative paths for Bicep file references, this step modifies the path inside the `.bicepparam` file to point to the correct location. It also moves the Bicep files to the root directory of the workflow to ensure correct relative pathing.

8. **Deploy to Azure**:
   - Using the `az deployment group create` command, the Bicep template is deployed to the specified Azure Resource Group.

### Key Considerations:

- **File Paths**: Due to Azure CLI's pathing expectations, relative paths are crucial. The workflow adjusts file paths and moves files to ensure the Azure CLI command can find and use the Bicep files.

- **Environment Variables**: The deployment is highly parameterized, using environment variables to dictate which Bicep file to deploy and where. This makes the workflow flexible and allows for future expansions.

- **Security**: The workflow uses GitHub Secrets to securely store Azure Service Principal credentials. These secrets are never exposed in logs or outputs.

- **Artifacts**: Artifacts (Bicep templates and parameters) are uploaded for traceability, allowing one to see which Bicep files were used in a specific run.

### Summary:

This workflow validates and deploys Azure resources using Bicep templates. It's designed to be flexible and adaptable, making it suitable for various deployment scenarios. Proper care has been taken to ensure security and traceability, two crucial aspects of infrastructure deployment.