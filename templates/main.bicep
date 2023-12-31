// Main Deployment Bicep File

param purpose string
param location string
param environment string
param vmAdmin string
param vmSize string
param bootStorage string
@secure()
param vmAdminPassword string
param osPublisher string
param osOffer string 
param osSKU string
param osVersion string
param time string = utcNow()

module vmModule 'br:eruza123.azurecr.io/bicep/modules/vm:v0.1.11' = {
  name: 'vmDeploy-${time}'
  params: {
    location: location
    environment: environment
    purpose: purpose
    vmAdmin: vmAdmin
    vmSize: vmSize
    bootStorage: bootStorage
    vmAdminPassword: vmAdminPassword
    osPublisher: osPublisher
    osOffer: osOffer
    osSKU: osSKU
    osVersion: osVersion
  }
}


