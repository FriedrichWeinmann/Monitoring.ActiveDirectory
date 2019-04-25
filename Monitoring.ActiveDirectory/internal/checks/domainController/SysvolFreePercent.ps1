$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	$volumeName = (Get-SmbShare -Name SYSVOL -CimSession $Connections.WinRM_CIM).Volume
	$volume = Get-Volume -CimSession $Connections.WinRM_CIM -UniqueId $volumeName
	$volume.SizeRemaining / $volume.Size * 100
}

$paramRegisterMonCheck = @{
	Name  = 'domaincontroller_SysvolFreePercent'
	Tag   = 'domaincontroller'
	Check = $check
	Description = 'Returns the percent of free storage on the volume hosting sysvol'
	Module	    = 'ActiveDirectory'
	RecommendedLimit = 20
	RecommendedLimitOperator = 'GreaterThan'
}

Register-MonCheck @paramRegisterMonCheck