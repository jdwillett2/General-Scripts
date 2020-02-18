Push-location
Set-location "HKLM:\Software\Javasoft\Java Update\"

if(Test-Path "HKLM:\Software\Javasoft\Java Update\Policy" -ea 0) 
    {'Key exists'}
Else 
    {New-Item Policy}

Set-location "HKLM:\Software\Javasoft\Java Update\Policy"
Set-ItemProperty . EnableJavaUpdate "0" -type dword
Set-ItemProperty . NotifyDownload "0" -type dword
Set-ItemProperty . NotifyInstall "0" -type dword
Set-ItemProperty . EnableAutoUpdateCheck "0" -type dword

Pop-Location