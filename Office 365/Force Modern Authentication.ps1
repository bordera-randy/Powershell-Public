
# Force modern authentication on Outlook 2013
reg add HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Identity /t REG_DWORD /v EnableADAL /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Identity /t REG_DWORD /v Version /d 1 /f


