function Test-GuiCompatibility
{
	#Requires -Version 3.0
	[CmdletBinding(SupportsShouldProcess = $True)]
	[OutputType([Bool])]
	Param
	()

	Begin
	{
		@('Get-Platfom.ps1') |
			ForEach-Object {
				Import-Module -Name (Join-Path $PSScriptRoot $_) -Force
			}

		$LastMajorWindowsPoSh = 5
		$FirstMajorPoShCore = 6

		$Platform = Get-Platform

		if (-Not [Enum]::Equals($Platform, [PlatformID]::Win32NT))
		{
			Write-Debug "Platform was detected to not be Windows. Current platform is : $Platform"
			return $False
		}

		Write-Debug 'Only Windows should reach this point and beyond.'
		Write-Debug "Current Platform : $Platform"

		if ($PSVersionTable.PSVersion.Major -le $LastMajorWindowsPoSh)
		{
			return $True
		}

		# NOTE : .NET Core 3.0 will allow for Windows Forms and WPF on Windows,
		# this means the first version of PowerShell Core based on .NET Core 3.0
		# will likely allow for GUIs to be used, so this will be updated when
		# that occurs.

		if ($PSVersionTable.PSVersion.Major -ge $FirstMajorPoShCore)
		{
			return $False
		}
	}
}
