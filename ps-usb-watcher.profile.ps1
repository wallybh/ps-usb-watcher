Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

if((Get-EventSubscriber | where {$_.SourceIdentifier -like "*disk*" }))
{
    Unregister-Event -SourceIdentifier disk
}

#destination folder
#todo ainda tenho que resolver como armazenar esse tipo de configuração. Sem paciencia pra resolver agora.
$global:usbWatcherDestFolder = [Environment]::GetFolderPath('MyVideos')


$Query = "select * from __InstanceCreationEvent within 5 where TargetInstance ISA 'Win32_LogicalDisk' and TargetInstance.DriveType = 2";



#
$importScriptPath = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Register-WmiEvent -Query $Query -SourceIdentifier disk -Timeout 1000 -Action { & ('{0}\Import-USBFiles.ps1' -f $importScriptPath);  }
##Register-WmiEvent -Query $Query -SourceIdentifier disk -Timeout 1000 -Action { & write-host (Get-Member -InputObject $event.SourceEventArgs.NewEvent.TargetInstance);  }

Pop-Location