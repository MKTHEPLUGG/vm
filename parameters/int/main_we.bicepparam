
param purpose string = 'shared'

param location string ='#{LOCATION}#'

param environment string = '#{ENVIRONMENT}#'

param vmAdmin string = 'adminUser'

param vmSize string = 'Standard_D2s_v3'

param subscriptionId string = ''

param subscriptionId string = '${SUBSCRIPTION_ID}'

param bootStorage string = 'mystorageacc'

@secure()
param vmAdminPassword string = 'mySecurePassword123!'

param osPublisher string = 'Canonical'

param osOffer string = 'UbuntuServer'

param osSKU string = '18.04-LTS'


param osVersion string = 'latest'

param gitRepo string = '#{Build.Repository.Name}#'

param gitRef string = '#{GitVersion.SemVer}#'

