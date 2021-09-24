$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		(Get-Service -Name Netlogon).Status
	}
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Service_NETLOGON'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Checks whether the Netlogon service is running'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = 'Running'
	RecommendedLimitOperator = 'Equal'
}
Register-MonCheck @paramRegisterMonCheck