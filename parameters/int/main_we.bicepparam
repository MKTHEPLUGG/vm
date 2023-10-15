@description('The purpose of the deployment')
param purpose string = 'shared'

@description('Azure location')
param location string = 'westeurope'

@description('Deployment environment')
param environment string = 'integration'

@description('Admin user for the VM')
param vmAdmin string = 'adminUser'

@description('Size of the VM')
param vmSize string = 'Standard_D2s_v3'

@description('Subnet ID for the VM')
param subnetId string = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}'

@description('Boot storage for VM')
param bootStorage string = 'mystorageacc'

@description('Admin password for VM')
@secure()
param vmAdminPassword string = 'mySecurePassword123!'

@description('OS Publisher')
param osPublisher string = 'Canonical'

@description('OS Offer')
param osOffer string = 'UbuntuServer'

@description('OS SKU')
param osSKU string = '18.04-LTS'

@description('OS Version')
param osVersion string = 'latest'

@description('Git repository')
param gitRepo string = '#{Build.Repository.Name}#'

@description('Git reference')
param gitRef string = '#{GitVersion.SemVer}#'

