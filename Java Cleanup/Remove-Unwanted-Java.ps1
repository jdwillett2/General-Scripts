#Removes all versions of Java that have product code input via pipeline, then changes some registry settings to disable Java Update (theoretically, anyways)
#Jesse Willett, IU Health Bloomington 7/14/2015

Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Code)

#Remove Java based on input from pipeline
Process {
	start-process "msiexec.exe" -arg "/x $Code /qn /norestart" -wait -RedirectStandardError error.txt -RedirectStandardOutput output.txt
}
#Set Registry keys to disable Java Update
End {
    Push-location

    Set-Location "HKLM:\Software\Javasoft"

    if(Test-Path ".\Java Update\" -ea 0)
        {"Key exists"}
    Else
        {New-Item -name "Java Update"}

    Set-location "HKLM:\Software\Javasoft\Java Update\"

    if(Test-Path .\Policy -ea 0) 
        {'Key exists'}
    Else 
        {New-Item Policy}

    Set-location "HKLM:\Software\Javasoft\Java Update\Policy"
    Set-ItemProperty . EnableJavaUpdate "0" -type dword
    Set-ItemProperty . NotifyDownload "0" -type dword
    Set-ItemProperty . NotifyInstall "0" -type dword
    Set-ItemProperty . EnableAutoUpdateCheck "0" -type dword

    Pop-Location
}