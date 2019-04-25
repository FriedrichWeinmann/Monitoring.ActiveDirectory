$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	Invoke-Command -Session $Connections.WinRM_PS -ScriptBlock {
		((Get-ADReplicationConnection -Server $using:TargetName).ReplicateFromDirectoryServer | Measure-Object).Count
	}
}

$paramRegisterMonCheck = @{
	Name	    = 'domaincontroller_ADDS_ReplicationLinkCount'
	Tag		    = 'domaincontroller'
	Check	    = $check
	Description = 'Returns the number of servers the target replicates with.'
	Module	    = 'ActiveDirectory'
}

Register-MonCheck @paramRegisterMonCheck