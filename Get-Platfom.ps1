function Get-Platform
{
	#Requires -Version 2.0
	[CmdletBinding()]
	[OutputType([PlatformID])]
	Param
	()

	if ($PSVersionTable.PSVersion.Major -le 5)
	{
		if ($Env:OS -eq 'Windows_NT')
		{
			return [PlatformID]::Win32NT
		}
		else
		{
			Write-Error 'Could not determine operating-system.'
		}
	}
	elseif ($PSVersionTable.PSVersion.Major -ge 6)
	{
		 switch ($True)
		{
			$IsWindows
			{
				return [PlatformID]::Win32NT
			}
			$IsMacOS
			{
				return [PlatformID]::MacOSX
			}
			$IsLinux
			{
				return [PlatformID]::Unix
			}
		}

	}
	else
	{
		Write-Error 'Could not determine PowerShell version.'
	}
}
