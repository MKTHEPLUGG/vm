param purpose = 'shared'
param location = 'westeurope'
param environment = 'integration'

@secure()
param vmAdminPassword = 'mySecurePassword123!'
param vmAdmin = 'adminUser'
param vmSize= 'Standard_D2s_v3'

param subscriptionId = ''

param bootStorage = 'mystorageacc'

param osPublisher = 'Canonical'
param osOffer = 'UbuntuServer'
param osSKU = '18.04-LTS'
param osVersion = 'latest'

param gitRepo = '#{Build.Repository.Name}#'
param gitRef = '#{GitVersion.SemVer}#'

