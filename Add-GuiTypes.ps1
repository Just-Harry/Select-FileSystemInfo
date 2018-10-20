function Add-GuiTypes
{
	#Requires -Version 3.0
	[CmdletBinding()]
	[OutputType([Void])]
	Param
	()

	Begin
	{
		@('System.Drawing', 'System.Windows.Forms') |
			ForEach-Object{
				Add-Type -AssemblyName $_
			}

		$WindowsAPICodePack = @('Microsoft.WindowsAPICodePack.dll', 'Microsoft.WindowsAPICodePack.Shell.dll')
		$WindowsAPICodePack |
			ForEach-Object {
				Add-Type -LiteralPath (Join-Path (Join-Path $PSScriptRoot 'bin') $_)
			}
	}
}
