$List = Get-Content ".\list.txt"  
Start-Transcript -Path ".\bitlockertranscript.txt" -Force 
foreach ($Computer in $List) {  
  
        if (test-Connection -ComputerName $Computer -Count 1 -Quiet ) {   
          
            Get-ADComputer -Identity $Computer -Property * | Select Name,OperatingSystem
            Get-WmiObject -class Win32_Tpm -namespace root\CIMV2\Security\MicrosoftTpm  -computername $Computer | fl IsActivated_InitialValue, IsEnabled_InitialValue, IsOwned_InitialValue  
            $BitLocker = Get-WmiObject -ComputerName $Computer -Namespace Root\cimv2\Security\MicrosoftVolumeEncryption -Class Win32_EncryptableVolume
            $id = $BitLocker.GetKeyProtectors(3).volumekeyprotectorid | Select -First 1
            manage-bde.exe -cn $Computer -protectors -adbackup c: -id $id
            manage-bde.exe -on C: -cn $Computer
          
                    } else  
                      
                    {"No Connection to $Computer"  
              
                    }      
          
}
Stop-Transcript 