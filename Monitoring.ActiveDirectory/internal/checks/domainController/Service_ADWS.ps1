$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		(Get-Service -Name ADWS).Status -eq 'Running'
	}
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Service_ADWS'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Checks whether the ADWS service is running'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}
Register-MonCheck @paramRegisterMonCheck