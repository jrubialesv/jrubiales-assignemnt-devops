param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string
param dbhost string
param dbuser string
param dbpass string
param dbname string

var appServicePlanName_s = 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'

  properties: {

    reserved: true

  }
  sku: {
    name: appServicePlanName_s
  }

}
resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
name: appServiceAppName
location: location
kind: 'linux'
properties: {
  reserved: true
  serverFarmId: appServicePlan.id
  httpsOnly: true
  siteConfig: {
    appCommandLine: 'pm2 serve /home/site/wwwroot/dist --no-daemon --spa'

    appSettings: [
      {
        name: 'DBUSER'
        value: dbuser
      }
      {
        name: 'DBPASS'
        value: dbpass
      }
      {
        name: 'DBNAME'
        value: dbname
      }
      {
        name: 'DBHOST'
        value: dbhost
      }
    ]
  }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
