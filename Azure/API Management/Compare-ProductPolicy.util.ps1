<#
.SYNOPSIS
	Script to compare tenant product policy between PRD and DR.

.DESCRIPTION
    Name: Compare-ProductPolicy.util.ps1
    Author: Randy Bordeaux 
    Date Created: 06/08/2022
    Date Modified:
    
    Description: 
        Download API Management Product Policy to a text file. Files will be named with the product ID and the date downloaded (Date Format MMddYYY).
        File Location: c:\az\apim
        Example: 10077341-SQLAPI-06032022.txt

        After product policy has been downloaded from both PRD and DR, a comparison will start
        Results will show ONLY lines that are different. 

        NOTE: url's will be different and are expected to be different based on the region
        
    Requirements: 
        Modules: 
            AZ 

    Documentation: 

#>
using namespace System.Net
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<# Variables #>
    $tenantId                   = 'VALUEHERE'                # tenant ID to search APIM products

<# Production Tenant #>
    $PRDAPIMName 			    = 'VALUEHERE' 		    # APIM service name
    $PRDAPIMresourceGroupName   = 'VALUEHERE' 	# APIM resource group name

<# DR Tenant #>
    $DRAPIMName 			    = 'VALUEHERE' 		    # APIM service name
    $DRAPIMresourceGroupName    = 'VALUEHERE' 	# APIM resource group name

################################## DO NOT CHANGE ##################################
$subfilter     = 'VALUEHERE'   # text filter to search AZ Subscription Name
$subscriptions = Get-AzSubscription | Where-Object Name -like *$subfilter* 
Set-AzContext -Subscription $subscriptions.Id -Tenant $subscriptions.TenantId

function Get-ProductPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$APIMName,
        [Parameter(Mandatory)]
        [string]$foldername,
        [Parameter(Mandatory)]
        [string]$APIMresourceGroupName 
    )


    $apiContext   = New-AzApiManagementContext -ResourceGroupName $APIMresourceGroupName -ServiceName $APIMName
    $products     = Get-AzApiManagementProduct -Context $apicontext
    $productList = [system.collections.arraylist]@{}
    $date = Get-Date -Format "MMddyyyy"
    $path = "c:\az\apim\$foldername"
    $testpath = test-path $path
    if (!$testpath) {
        mkdir -Path $path -erroraction 'SilentlyContinue'
    }
    foreach ($item in $Products) {
        $productList += $newProduct.ProductId
    }

    foreach ($product in $products) {
        $policypath = ($path + "\" + $($product.ProductId) + ".txt")
        
        if ($null -eq $product.ProductId) {
            Write-Host "productid is null" -ForegroundColor RED
            $product
            break
        }
        if ($product.ProductId -eq $tenantId -or $product.ProductId -like $("$($tenantId)*")) {
            Write-Host("`n*************BEGIN************`n$($product.ProductId )") -ForegroundColor Yellow
            Write-Host "`nProcessing product $($product.ProductId)" -ForegroundColor Yellow
            $subscriptions = Get-AzApiManagementSubscription -Context $apicontext -ProductId $product.ProductId
            Get-AzApiManagementPolicy -Context $apicontext -ProductId $product.ProductId | Add-Content -Path $policypath
            Write-Host("*** Processing Complete for $($product.productid) ***`n") -ForegroundColor Green
        }
    }           
}

function Compare-ProductPolicy {
    param (
        [Parameter(Mandatory)]
        [string]$PRDfoldername,

        [Parameter(Mandatory)]
        [string]$DRfoldername
    )
    
    $PRDpath = "c:\az\apim\"
    $DRpath = "c:\az\apim\"
    $prdtenantconfig = (get-childitem $($PRDpath +  $PRDfoldername))
    foreach ($Item in $prdtenantconfig) {
        try {
            $i = 0 
        Write-Host -ForegroundColor Magenta "Comparing $item"
        Write-Host -ForegroundColor Magenta "Side indicator will determine which file is different"
        Write-Host -ForegroundColor Magenta "<== means the PRD file contains the property"
        Write-Host -ForegroundColor Magenta "==> means the DR file contains the property"
        Write-Host -ForegroundColor Magenta "=>= or =<= means both files contain the property, but they are different"
        
        $diff = compare-object -ReferenceObject  $(get-content $($PRDpath +  $PRDfoldername + "\"  + $Item)) -DifferenceObject $(get-content $($DRpath + $DRfoldername + "\" + $Item))  | Select-Object *
        if ($diff) {
            do {
                Write-Host -ForegroundColor Yellow $($diff[$i++] | Select-Object inputobject )
                Write-Host -ForegroundColor Magenta $($diff[$i++] | Select-Object sideindicator )
                
            } until (!$diff[$i])
        }
        pause    
        }
        catch {
            Write-Host -ForegroundColor darkRed -BackgroundColor Yellow "$item is MISSING!!!" 
            Write-Host -ForegroundColor Red  "Check the PRD and DR APIM Products for the missing product. If it does exist, check the $path directory" 
        }       
    }
}

Get-ProductPolicy -APIMName $PRDAPIMName -APIMresourceGroupName $PRDAPIMresourceGroupName -foldername $("PRD" + $tenantId) 
Get-ProductPolicy -APIMName $DRAPIMName -APIMresourceGroupName $DRAPIMresourceGroupName -foldername $("DR" + $tenantId) 
Compare-ProductPolicy -PRDfoldername $("PRD" + $tenantId) -DRfoldername $("DR" + $tenantId)
