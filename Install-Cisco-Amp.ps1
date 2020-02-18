Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Server)

Process {
	
        if (Test-Connection -ComputerName $server -count 1 -quiet) {
            write-host "$server is online, connecting..." -BackgroundColor Yellow -ForegroundColor Black
            copy-item -Path .\IUH_Protect_Server_FireAMPSetup.exe -Destination \\$server\c$
            psexec.exe -s \\$server c:\IUH_Protect_Server_FireAMPSetup.exe /R /S 2> $null
            Remove-Item -Path \\$server\c$\IUH_Protect_Server_FireAMPSetup.exe
            }
        else {
            write-host "$server is not online" -BackgroundColor Red -ForegroundColor White
            }
}
