function Get-MonADCheck
{
<#
	.SYNOPSIS
		Lists all checks introduced by this Management Pack module.
	
	.DESCRIPTION
		Lists all checks introduced by this Management Pack module.
	
	.PARAMETER Name
		Filter checks by name.
	
	.EXAMPLE
		PS C:\> Get-MonADCheck
	
		Lists all checks introduced by this Management Pack module.
#>
	[CmdletBinding()]
	param (
		[string]
		$Name = "*"
	)
	
	process
	{
		Get-MonCheck | Where-Object Module -EQ 'ActiveDirectory' | Where-Object Name -Like $Name | Sort-Object Name
	}
}