$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		(Get-Service -Name NTDS).Status -eq 'Running'
	}
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Service_NTDS'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Checks whether the NTDS service is running'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}
Register-MonCheck @paramRegisterMonCheck