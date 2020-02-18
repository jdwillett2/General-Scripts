<#
Written by Jesse Willett to remove SCCM Client from devices. 1/27/2015

Accepts piped input from text file or listed input on command line.

Runs the uninstaller first, then runs ccmclean.exe, then deletes what is left and restarts the remote computer.
#>

Param([Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]$Workstation)

Process {
	$ActualPath = $PSScriptRoot
	$RemoveCCM = {
		Param([Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]$Workstation,$ActualPath)
		$LogFile = "$ActualPath\Logs\$Workstation-CCMUninstall.log"
        $ErrorFile = "$ActualPath\Logs\Errors.log"
        $SuccessFile = "$ActualPath\Logs\Success.log"
			if (Test-Connection -computername $Workstation -count 1 -quiet) {
				(get-date -format g)  + ": $Workstation : Starting ccmsetup uninstall" >> $LogFile
				psexec.exe \\$Workstation -e C:\Windows\CCMSetup\ccmsetup.exe  /uninstall
				(get-date -format g)  + ": $Workstation : ccmsetup exited with exit code $LASTEXITCODE" >> $LogFile
				cp $ActualPath\CCMClean.exe \\$Workstation\c$\CCMClean.exe
				(get-date -format g) + ": $Workstation : Starting ccmclean.exe" >> $LogFile
				psexec.exe \\$Workstation -e C:\CCMClean.exe /q
				(get-date -format g) + ": $Workstation : ccmclean exited with exit code $LASTEXITCODE" >> $LogFile
				<#(get-date -format g) + ": $Workstation : Restarting Computer..." >> $LogFile
				Restart-Computer -ComputerName $Workstation -Force -Wait -For WMI -Timeout 600#>
				(get-date -format g) + ": $Workstation : Performing final cleanup..." >> $LogFile
                Start-Sleep -s 10
				Remove-Item \\$Workstation\c$\Windows\SMSCFG.ini -recurse
				Remove-Item \\$Workstation\c$\Windows\CCM -recurse -force
				Remove-Item \\$Workstation\c$\Windows\ccmsetup -recurse -force
                Remove-Item \\$Workstation\c$\Windows\ccmcache -Recurse -force
                Remove-Item \\$Workstation\c$\CCMClean.exe
				(get-date -format g)  + ": $Workstation : Finished Uninstall" >> $LogFile
                "$Workstation :" + (get-date -Format g) >> $SuccessFile
			}

			else {(get-date -format g) + ": $Workstation : Error, cannot ping computer." >> $LogFile
                    "$Workstation :" + (get-date -Format g) >> $ErrorFile}
	}

    Start-Job -ScriptBlock $RemoveCCM -ArgumentList $Workstation,$ActualPath
    Start-Sleep -Seconds 2
}

<#(get-date -format g) + ": $Workstation : Error, cannot ping computer." >> $LogFile#>