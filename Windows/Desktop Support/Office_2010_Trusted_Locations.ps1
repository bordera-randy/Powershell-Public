
#--------------------------------------------------
# Helpful Weblinks for script
#--------------------------------------------------

# http://technet.microsoft.com/en-us/library/cc179039.aspx#implementlocations
# http://technet.microsoft.com/en-us/library/dd315394.aspx
#



#--------------------------------------------------
# Global Variables Section
#--------------------------------------------------

#Date
#
$setDATE = (Get-Date).ToString()
#
# trusted Location to Add Addd Your templates Path or location path
#
$trustlocation = 'C:\macros'    # <---- Change this as per your requirement
#
# Note I am using Location99 as a KEY so that i can test it and i know that is created by me.
#
$regWORD = 'HKCU:\Software\Microsoft\Office\14.0\Word\Security\Trusted Locations\Location99'
# Testing if Location 9 Key Exists in word.
$testWORDPAth = Test-Path $regWORD
#
#
$regEXCEL = 'HKCU:\Software\Microsoft\Office\14.0\Excel\Security\Trusted Locations\Location99'
# Testing if Location 9 Key Exists in Excel registry Key.
$testEXCELPATH = Test-Path $regEXCEL
#
#
$regPPT = 'HKCU:\Software\Microsoft\Office\14.0\Powerpoint\Security\Trusted Locations\Location99'
# Testing if Location 9 Key Exists in PowerPoint.
$testPPTPATH = Test-Path $regPPT
#
#
$setDesription = "Trusted location for South Texas Money Management in-house Templates"   #<----------- You can change the Description
#
# Registry Keys Need to be Create
#
# AllowSubfolders = 1
# Date = todays Date
# Description = setDescription
# Path = location

#--------------------------------------------------
# Global Variables Section Ends Here | 
#--------------------------------------------------


#--------------------------------------------------
# Script Section
#--------------------------------------------------

#
# For Word
#

if ( $testWORDPAth -eq $false) {
	
	Write-Host "==> Adding Trusted Location for Microsoft Word" -ForegroundColor 'Green'
	New-Item -Path $regWORD -type Directory -Force | Out-Null
	New-ItemProperty -Path $regWORD -Name "Date" -Value $setDATE | Out-Null
	New-ItemProperty -Path $regWORD -Name "Description" -Value $setDesription | Out-Null
	New-ItemProperty -Path $regWORD -Name "Path" -Value $trustlocation | Out-Null
	New-ItemProperty -Path $regWORD -Type DWord  -Name "AllowSubfolders" -Value 1 | Out-Null
		
	} else { 
	Write-Host "==>  Word Templated are already added in Trusted Locations."  -ForegroundColor 'Green'
	}

#
# For Excel
#

if ( $testEXCELPATH -eq $false) {
	
	Write-Host "==> Adding Trusted Location for Microsoft Excel." -ForegroundColor 'Cyan'
	New-Item -Path $regEXCEL -type Directory -Force | Out-Null
	New-ItemProperty -Path $regEXCEL -Name "Date" -Value $setDATE | Out-Null
	New-ItemProperty -Path $regEXCEL -Name "Description" -Value $setDesription | Out-Null
	New-ItemProperty -Path $regEXCEL -Name "Path" -Value $trustlocation | Out-Null
	New-ItemProperty -Path $regEXCEL -Type DWord  -Name "AllowSubfolders" -Value 1 | Out-Null
	} else { 
	Write-Host "==> Excel Templates are already added in Trusted Locations."  -ForegroundColor 'Cyan'
	}

#
# For Powerpoint
#

if ( $testPPTPATH -eq $false) {
	
	Write-Host "==> Adding Trusted Location for Microsoft Powerpoint." -ForegroundColor 'Magenta' 
	New-Item -Path $regPPT -type Directory -Force | Out-Null
	New-ItemProperty -Path $regPPT -Name "Date" -Value $setDATE | Out-Null
	New-ItemProperty -Path $regPPT -Name "Description" -Value $setDesription | Out-Null
	New-ItemProperty -Path $regPPT -Name "Path" -Value $trustlocation | Out-Null
	New-ItemProperty -Path $regPPT -Type DWord  -Name "AllowSubfolders" -Value 1 | Out-Null
		
	} else { 
	Write-Host "==> Powerpoint Templates are already added in Trusted Locations."  -ForegroundColor 'Magenta'
	}


#--------------------------------------------------
# Script Section Ends Here ||
#--------------------------------------------------


