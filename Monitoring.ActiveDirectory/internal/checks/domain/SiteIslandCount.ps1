$check = {
	param (
		$TargetName,
		
		$Connections
	)
	
	$domain = Get-ADDomain -Identity $TargetName
	$pdcEmulator = $domain.PDCEmulator
	$sites = Get-ADReplicationSite -Filter * -Server $pdcEmulator
	# Skip if only a single site
	if (($sites | Measure-Object).Count -lt 2) { return 0 }
	$domainController = Get-ADDomainController -Filter * -Server $pdcEmulator
	$replConnections = Get-ADReplicationConnection -Server $pdcEmulator -Filter * | ForEach-Object {
		[pscustomobject]@{
			From = (Get-ADObject -Identity $replConnections[-1].ReplicateFromDirectoryServer.Split(',', 2)[1] -Properties serverReference).ServerReference
			To   = (Get-ADObject -Identity $replConnections[-1].ReplicateToDirectoryServer -Properties serverReference).ServerReference
		}
	}
	
	$countIslands = 0
	$sitesProcessed = 0
	
	:main foreach ($site in $sites)
	{
		$localDCs = $domainController | Where-Object Site -EQ $site.Name
		if (-not $localDCs) { continue }
		$sitesProcessed = $sitesProcessed + 1
		$foreignDCs = $domainController | Where-Object Site -NE $site.Name
		foreach ($domainControllerItem in $localDCs)
		{
			$outsideLinks = $replConnections | Where-Object From -EQ $domainControllerItem.ComputerObjectDN | Where-Object {
				$link = $_
				$foreignDCs | Where-Object ComputerObjectDN -EQ $link.To
			}
			# Found an outside link!
			if ($outsideLinks) { continue main }
			
			$outsideLinks = $replConnections | Where-Object To -EQ $domainControllerItem.ComputerObjectDN | Where-Object {
				$link = $_
				$foreignDCs | Where-Object ComputerObjectDN -EQ $link.From
			}
			# Found an outside link!
			if ($outsideLinks) { continue main }
		}
		$countIslands = $countIslands + 1
	}
	
	# Multiple sites, but only one with DCs
	if ($sitesProcessed -eq 1) { return 0 }
	$countIslands
}

$paramRegisterMonCheck = @{
	Name  = 'domain_SiteIslandCount'
	Tag   = 'domain'
	Check = $check
	Description = 'Scans whether a site has isolated itself by not replicating to other sites with domain controllers'
	Module	    = 'ActiveDirectory'
	RecommendedLimit = 0
	RecommendedLimitOperator = 'Equal'
}

Register-MonCheck @paramRegisterMonCheck