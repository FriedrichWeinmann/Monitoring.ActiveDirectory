$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		(Get-Service -Name W32Time).Status -eq 'Running'
	}
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Service_W32Time'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Checks whether the W32Time service is running'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}
Register-MonCheck @paramRegisterMonCheck