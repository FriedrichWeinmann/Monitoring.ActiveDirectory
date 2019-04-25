$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	try
	{
		$null = Get-ADDomain -Server $TargetName -ErrorAction Stop
		return $true
	}
	catch { return $false }
}

$paramRegisterMonCheck = @{
	Name					 = 'domaincontroller_Connect_ADWS'
	Tag					     = 'domaincontroller'
	Check				     = $check
	Description			     = 'Tests, whether it is possible to connect to the target via Active Directory Web Services (the service used by the Active Directory PowerShell module)'
	Module				     = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}

Register-MonCheck @paramRegisterMonCheck