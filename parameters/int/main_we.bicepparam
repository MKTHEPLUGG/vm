using '../../templates/main.bicep'

param purpose = 'shared'
param location = 'westeurope'
param environment = 'integration'

@secure()
param vmAdminPassword = 'mySecurePassword123!'
param vmAdmin = 'adminUser'
param vmSize= 'Standard_D2s_v3'

param bootStorage = 'randombandomphanton'

param osPublisher = 'Canonical'
param osOffer = 'UbuntuServer'
param osSKU = '18.04-LTS'
param osVersion = 'latest'
