configuration IISConfig {
    Node WebServer {
       WindowsFeature IIS {
          Ensure               = 'Present'
          Name                 = 'Web-Server'
          IncludeAllSubFeature = $true
       }
    }
 }