you can use replace tokens to replace string that match the env vars from actions pipeline inside the anyfile

```bash
env:
  environment: prod

# in other file
param environment= '#{environment}'

```

action

````github actions
    - name: Replace tokens
      uses: cschleiden/replace-tokens@v1.2
      with:
        files: parameters/${{ inputs.environment }}/${{ inputs.templateFile }}_${{ inputs.location }}.bicepparam

``