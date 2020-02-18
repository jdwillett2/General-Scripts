Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$server)

Process {
	start-process "$pshome\powershell.exe" -argumentlist "-command .\Install-Cisco-Amp.ps1 $server"
}