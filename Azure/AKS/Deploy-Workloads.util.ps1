<#
.SYNOPSIS
    Deploy new workloads to AKS Cluster

.DESCRIPTION
    
    Name: Deploy-Workloads.util.ps1
    Date Created: 1/27/2022
    Date Modified:
    Author: Randy Bordeaux
    Contributors:

    Description: This script will connect to the UNC DEV cluster, and deploy the workloads in the YAML file specified in the $yaml1 and $yaml2 variables. This is designed to run interactively

.EXAMPLE

    PS C:\> Deploy-Workloads.util.ps1
    Run this interactively, by opening vscode or powershell ISE and executing the script

.INPUTS
        
    The following variables need to be updated prior to running the script    

    $aztenantid         = 'VALUEHERE'
    $azsubscriptionid   = 'VALUEHERE'
    $AKSrg              = 'VALUEHERE'
    $AKScluster         = 'VALUEHERE'
    $yaml1              = 'VALUEHERE'                                Local Path to yaml file 
    $yaml2              = 'VALUEHERE'                                Local Path to yaml file     
    $yml1               = 'VALUEHERE'                                Local Path to yml file 
    $yml2               = 'VALUEHERE'                                Local Path to yml file 

.OUTPUTS

.NOTES

    
#>

<# Variables #>
$aztenantid         = 'VALUEHERE'
$azsubscriptionid   = 'VALUEHERE'
$AKSrg              = 'VALUEHERE'
$AKScluster         = 'VALUEHERE'
$yaml1              = 'VALUEHERE'
$yaml2              = 'VALUEHERE'
$yml1               = 'VALUEHERE'
$yml2               = 'VALUEHERE'


$logfile            = 'c:\vscode\logs\Deploy-AKS-Workloads-Transcript.txt'
# Create log folder location 
mkdir C:\vscode\logs -ErrorAction SilentlyContinue
Start-Transcript -Path $logfile

# Set AZ context
set-azcontext $azsubscriptionid -Tenant $aztenantid

# To connect to Cluster 
az account set --subscription  $azsubscriptionid
az aks get-credentials --resource-group $AKSrg --name $AKScluster

cls 

kubectl cluster-info $AKScluster
Write-Host ""
Write-Host -ForegroundColor red "Please verify you have connected to the proper cluster. If you have NOT, press CTRL + C to cancel"
Pause 
Write-Host -ForegroundColor Yellow "Deploying workloads from $yaml1"
kubectl apply -f $yaml1
Write-Host -ForegroundColor Yellow "Deploying workloads from $yml1"
kubectl apply -f $yml1
Write-Host -ForegroundColor Yellow "Deploying workloads from $yaml2"
kubectl apply -f $yaml2
Write-Host -ForegroundColor Yellow "Deploying workloads from $yml2"
kubectl apply -f $yml2

Write-Host -ForegroundColor Magenta "Workloads have been deployed."
Write-Host -ForegroundColor Magenta "Please check the AKS Cluster $akscluster for the workloads"

Write-Host -ForegroundColor Blue "DONE"
