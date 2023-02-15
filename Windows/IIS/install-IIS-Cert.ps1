<#
  This script will import and bind a certificate to the Default
  Web Site for use with Citrix StoreFront, etc.

  The original idea came from scripts written by Thomas Albaek and
  Jerome Quief:
  - http://www.albaek.org/automatic-installation-of-citrix-storefront-2-6/
  - https://jeromequief.wordpress.com/2014/06/11/storefront-2-5-unattended-install-and-config/

  I have enhanced and modernized it. You can either pass parameters
  to it, or hardcode them. The nice thing about this script is that
  it can also be used to remove/update certificates.

  Syntax examples:

    Using hardcoded variables:
      Install-Certificate.ps1

    Passing parameters:
      Install-Certificate.ps1 -PFXPath:".\star_jhouseconsulting_com.pfx" -PFXPassword:"notT3LL1ngu" -CertSubject:"CN=*.jhouseconsulting.com"

    The ExcludeLocalServerCert is optional, and is forced to $True
    if left off. You really never want this set to false, especially
    if using a wildcard certificate. It's there mainly for flexibility.

    If the password contains a $ sign, you must escape it with the `
    character.

  Script Name: Install-Certificate.ps1
  Release 1.0
  Written by Jeremy@jhouseconsulting.com 21st December 2014

  Note: This script has been tested thoroughly on Windows 2012R2
        (IIS 8.5). Due to the cmdlets used I cannot guarantee full
        backward compatibility.

  A log file will either be written to %windir%\Temp or to the
  %LogPath% Task Sequence variable if running from an SCCM\MDT
  Task.

#>

#-------------------------------------------------------------
param([String]$PFXPath,[String]$PFXPassword,[String]$CertSubject,[switch]$ExcludeLocalServerCert)

# Set Powershell Compatibility Mode
Set-StrictMode -Version 2.0

$ScriptPath = {Split-Path $MyInvocation.ScriptName}

if ([String]::IsNullOrEmpty($PFXPath)) {
  $PFXPath = $(&$ScriptPath) + "\star_jhouseconsulting_com.pfx"
}

if ([String]::IsNullOrEmpty($PFXPassword)) {
  $PFXPassword = "notT3LL1ngu"
}

if ([String]::IsNullOrEmpty($CertSubject)) {
  $CertSubject = "CN=*.jhouseconsulting.com"
}

if (!($ExcludeLocalServerCert.IsPresent)) { 
  $ExcludeLocalServerCert = $True
}

# Set to the Web Site
$sitename = "Default Web Site"

# Set to the Port number
$port = 443

#-------------------------------------------------------------

Function IsTaskSequence() {
  # This code was taken from a discussion on the CodePlex PowerShell
  # App Deployment Toolkit site. It was posted by mmashwani.
  Try {
      [__ComObject]$SMSTSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction 'SilentlyContinue' -ErrorVariable SMSTSEnvironmentErr
  }
  Catch {
  }
  If ($SMSTSEnvironmentErr) {
    Write-Verbose "Unable to load ComObject [Microsoft.SMS.TSEnvironment]. Therefore, script is not currently running from an MDT or SCCM Task Sequence."
    Return $false
  }
  ElseIf ($null -ne $SMSTSEnvironment) {
    Write-Verbose "Successfully loaded ComObject [Microsoft.SMS.TSEnvironment]. Therefore, script is currently running from an MDT or SCCM Task Sequence."
    Return $true
  }
}

#-------------------------------------------------------------

$invalidChars = [io.path]::GetInvalidFileNamechars() 
$datestampforfilename = ((Get-Date -format s).ToString() -replace "[$invalidChars]","-")

# Get the script path
$ScriptPath = {Split-Path $MyInvocation.ScriptName}
$ScriptName = [System.IO.Path]::GetFilenameWithoutExtension($MyInvocation.MyCommand.Path.ToString())
$Logfile = "$ScriptName-$($datestampforfilename).txt"
$logPath = "$($env:windir)\Temp"

If (IsTaskSequence) {
  $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
  $logPath = $tsenv.Value("LogPath")

  $UserDomain = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($tsenv.Value("UserDomain")))
  $UserID = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($tsenv.Value("UserID")))
  $UserPassword = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($tsenv.Value("UserPassword")))
}

$logfile = "$logPath\$Logfile"

# Start the logging 
Start-Transcript $logFile
Write-Output "Logging to $logFile"

#-------------------------------------------------------------

Write-Output "Start Certificate Installation"

Write-Output "Loading the Web Administration Module"
try{
    Import-Module webadministration
}
catch{
    Write-Output "Failed to load the Web Administration Module"
}

Write-Output "Deleting existing certificate from Store"
try{
    $cert = Get-ChildItem cert:\LocalMachine\MY | Where-Object {$_.subject -like "$CertSubject*" -AND $_.Subject -notmatch "CN=$env:COMPUTERNAME"}
    $thumbprint = $cert.Thumbprint.ToString()
    If (Test-Path "cert:\localmachine\my\$thumbprint") {
      Remove-Item -Path cert:\localmachine\my\$thumbprint -DeleteKey
    }
}
catch{
    Write-Output "Unable to delete existing certificate from store"
}

Write-Output "Running certutil to import certificate into Store"
try{
    $ImportError = certutil.exe -f -importpfx -p $PFXPassword $PFXPath
}
catch{
    Write-Output "certutil failed to import certificate: $ImportError"
}

Write-Output "Locating the cert in the Store"
try{
    If ($ExcludeLocalServerCert) {
      $cert = Get-ChildItem cert:\LocalMachine\MY | Where-Object {$_.subject -like "$CertSubject*" -AND $_.Subject -notmatch "CN=$env:COMPUTERNAME"}
    } Else {
      $cert = Get-ChildItem cert:\LocalMachine\My | Where-Object {$_.subject -like "$CertSubject*"}
    }
    $thumbprint = $cert.Thumbprint.ToString()
    Write-Output $cert
}
catch{
    Write-Output "Unable to locate cert in certificate store"
}

Write-Output "Removing any existing binding from the site and SSLBindings store"
try{
  # Remove existing binding form site  
  if ($null -ne (Get-WebBinding -Name $sitename | where-object {$_.protocol -eq "https"})) {
    $RemoveWebBinding = Remove-WebBinding -Name $sitename -Port $Port -Protocol "https"
    Write-Output $RemoveWebBinding
  }
  # Remove existing binding in SSLBindings store
  If (Test-Path "IIS:\SslBindings\0.0.0.0!$port") {
    $RemoveSSLBinding = Remove-Item -path "IIS:\SSLBindings\0.0.0.0!$port"
    Write-Output $RemoveSSLBinding
  }
}
catch{
    Write-Output "Unable to remove existing binding"
}

Write-Output "Bind your certificate to IIS HTTPS listener"
try{
  $NewWebBinding = New-WebBinding -Name $sitename -Port $Port -Protocol "https"
  Write-Output $NewWebBinding
  $AddSSLCertToWebBinding = (Get-WebBinding $sitename -Port $Port -Protocol "https").AddSslCertificate($thumbprint, "MY")
  Write-Output $AddSSLCertToWebBinding
}
catch{
    Write-Output "Unable to bind cert"
}

Write-Output "Completed Certificate Installation"
 
# Stop logging 
Stop-Transcript
