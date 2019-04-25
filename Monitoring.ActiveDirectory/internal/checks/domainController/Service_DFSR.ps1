$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		(Get-Service -Name DFSR).Status -eq 'Running'
	}
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Service_DFSR'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Checks whether the DFSR service is running'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}
Register-MonCheck @paramRegisterMonCheck