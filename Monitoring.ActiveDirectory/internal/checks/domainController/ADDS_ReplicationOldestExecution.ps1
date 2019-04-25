$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		$targets = (Get-ADReplicationConnection -Server $using:TargetName).ReplicateFromDirectoryServer
		$timestamps = foreach ($target in $targets)
		{
			$serverResolved = (Get-ADObject -Identity $target.Split(",", 2)[1] -Properties serverReference).serverReference
			$targetDNS = $serverResolved -replace '^CN=(.+?),.+?DC=(.+)$', '$1.$2' -replace ',DC=', '.'
			(Get-ADReplicationPartnerMetadata -Target $targetDNS).LastReplicationSuccess
		}
		$timestamps | Sort-Object | Select-Object -First 1
	}
}

$paramRegisterMonCheck = @{
	Name	    = 'domaincontroller_ADDS_ReplicationOldestExecution'
	Tag		    = 'domaincontroller'
	Check	    = $check
	Description = 'Scans all replication partners and returns how long ago the target successfully replicated with the one it hasn''t successfully replicated with for the longest time.'
	Module	    = 'ActiveDirectory'
}

Register-MonCheck @paramRegisterMonCheck