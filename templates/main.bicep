// Main Deployment Bicep File

param purpose string
param location string
param environment string
param vmAdmin string
param vmSize string
param subnetId string
param bootStorage string
@secure()
param vmAdminPassword string
param osPublisher string
param osOffer string 
param osSKU string
param osVersion string
param gitRepo string
param gitRef string
param time string

module vmModule 'br:eruza123.azurecr.io/bicep/modules/vm:v0.1.6 = {
  name: 'vmDeploy-${time}'
  params: {
    location: location
    environment: environment
    purpose: purpose
    vmAdmin: vmAdmin
    vmSize: vmSize
    subnetId: subnetId
    bootStorage: bootStorage
    vmAdminPassword: vmAdminPassword
    osPublisher: osPublisher
    osOffer: osOffer
    osSKU: osSKU
    osVersion: osVersion
    gitRef: gitRef
    gitRepo: gitRepo
  }
}
