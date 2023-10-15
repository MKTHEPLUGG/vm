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