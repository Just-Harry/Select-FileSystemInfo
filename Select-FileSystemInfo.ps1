function Select-FileSystemInfo
{
	#Requires -Version 3.0
	[CmdletBinding()]
	[OutputType([IO.FileSystemInfo[]])]
	Param
	(
		[Parameter(Mandatory = $False)]
				[IO.DirectoryInfo] $InitialDirectory = $HOME,

		[Parameter(Mandatory = $False)]
				[Switch] $SelectDirectories,

		[Parameter(Mandatory = $False)]
				[Switch] $SelectMultipleItems,

		[Parameter(Mandatory = $False)]
			[AllowNull()]
				[String] $Title
	)

	Begin
	{
		@('Test-GuiCompatibility.ps1', 'Add-GuiTypes.ps1') |
			ForEach-Object {
				Import-Module -Name (Join-Path $PSScriptRoot $_) -Force
			}

		if (-Not $Title)
		{
			$Title = if ($SelectDirectories.IsPresent)
			{
				if ($SelectMultipleItems.IsPresent)
				{
					'Please select some folders.'
				}
				else
				{
					'Please select a folder.'
				}
			}
			else
			{
				if ($SelectMultipleItems.IsPresent)
				{
					'Please select some files.'
				}
				else
				{
					'Please select a file.'
				}
			}
		}

		$GuiCapable = Test-GuiCompatibility

		if ($GuiCapable)
		{
			Write-Debug 'Performing GUI code-path.'

			Add-GuiTypes

			$Selecter = [Microsoft.WindowsAPICodePack.Dialogs.CommonOpenFileDialog]::New()
			$Selecter.InitialDirectory = $InitialDirectory.FullName
			$Selecter.IsFolderPicker   = $SelectDirectories.IsPresent
			$Selecter.Multiselect      = $SelectMultipleItems.IsPresent
			$Selecter.Title            = $Title

			$Selecter.ShowDialog() > $Null

			$SelectedItems = foreach ($Item in $Selecter.FileNames)
			{
				if ($SelectDirectories.IsPresent)
				{
					[IO.DirectoryInfo]::New($Item)
				}
				else
				{
					[IO.FileInfo]::New($Item)
				}
			}
			return $SelectedItems
		}
		else
		{
			Throw 'This operating-system or version of PowerShell does not support this GUI.'
		}
	}
}
