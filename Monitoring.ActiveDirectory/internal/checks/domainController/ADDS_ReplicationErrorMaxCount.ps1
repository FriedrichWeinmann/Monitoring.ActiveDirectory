$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		$targets = (Get-ADReplicationConnection -Server $using:TargetName).ReplicateFromDirectoryServer
		$errorCount = foreach ($target in $targets)
		{
			$serverResolved = (Get-ADObject -Identity $target.Split(",", 2)[1] -Properties serverReference -Server $using:TargetName).serverReference
			$targetDNS = $serverResolved -replace '^CN=(.+?),.+?DC=(.+)$', '$1.$2' -replace ',DC=', '.'
			(Get-ADReplicationPartnerMetadata -Target $targetDNS).ConsecutiveReplicationFailures
		}
		$errorCount | Sort-Object -Descending | Select-Object -First 1
	}
}

$paramRegisterMonCheck = @{
	Name  = 'domaincontroller_ADDS_ReplicationErrorMaxCount'
	Tag   = 'domaincontroller'
	Check = $check
	Description = 'Checks the highest amount of consecutive replication errors amongst all replication partners of the target'
	Module = 'ActiveDirectory'
}

Register-MonCheck @paramRegisterMonCheck