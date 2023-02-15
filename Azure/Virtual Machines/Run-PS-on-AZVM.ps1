<########################################################################################################################################################
    Name: Run-PS-on-AZVM
    Author: Randy Bordeaux
    Date Created: 8/06/2021
    Date Modified:
    
    Description: 
       Run scripts against multiple Azure virtual machines (VMs) by using PowerShell and the Invoke-AzVMRunCommand feature.
        
    Requirements: 
        Powershell 6.X.X or later
        NET Framework 4.7.2 or later
        
        The Powershell module 'AZ' is required to execute the commands in this script, Azure cloud shell can be used and comes with the AZ module installed
        already. 
        You can access the Cloud Shell at https://shell.azure.com
        
        PowerShell 7.x and later is the recommended version of PowerShell for use with the Azure Az PowerShell module on all platforms.
        
        How to install the AZ module 
            
            This method works the same on Windows, macOS, and Linux platforms. 
            Run the following command from a PowerShell session:
           
                Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
            
            The MSI package for Azure PowerShell is available from https://github.com/Azure/azure-powershell/releases
    Documentation: 
        https://docs.microsoft.com/en-us/powershell/azure/?view=azps-6.0.0
        https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.0.0
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1
        https://www.powershellgallery.com/packages/Az/6.0.0
        https://github.com/Azure/azure-powershell/releases
        https://shell.azure.com
########################################################################################################################################################>

# connect to Azure 
Connect-AzAccount

<# Variables #> 
$subscriptionId = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$resourceGroup = "test-azurevms-rg" #Resource Group my VMs are in

#Select the right Azure subscription
Set-AzContext -Subscription $subscriptionId

# Discover VMs in a running state and have windows installed 
$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

<# Execute script against all VMs #>
$myAzureVMs | ForEach-Object -Parallel {
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath .\script.ps1 
    #Formating the Output with the VM name
    $output = $_.Name + " " + $out.Value[0].Message
    $output   
}
