$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		if (dcdiag /q) { return $false }
		else { return $true }
	}
}

$paramRegisterMonCheck = @{
	Name  = 'domaincontroller_DCDIAG'
	Tag   = 'domaincontroller'
	Check = $check
	Description = 'Checks whether DCDIAG can find a problem on the DC. Returns $true if everything is fine.'
	Module = 'ActiveDirectory'
	RecommendedLimit		 = $true
	RecommendedLimitOperator = 'Equal'
}

Register-MonCheck @paramRegisterMonCheck