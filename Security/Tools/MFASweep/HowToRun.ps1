$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/bsonnek/MFASweep-master/main/MFASweep.ps1
Invoke-Expression $($ScriptFromGitHub.Content)
Invoke-MFASweep
