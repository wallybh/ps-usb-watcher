Write-Host "RECONHECENDO SEU USB!"

if((! $global:usbWatcherDestFolder) -or (! (Test-Path $global:usbWatcherDestFolder)))
    { Write-Error "Variável global `$usbWatcherDestFolder não encontrada. Verifique se ela está sendo setada no arquivo ps-usb-watcher.profile.ps1 corretamente ou execute o script novamente." }

#TODO falta validar se o drive é da gopro. gastei um tempão procurando e ainda não achei.

$fileQuery = ("{0}\*.mp4" -f $event.SourceEventArgs.NewEvent.TargetInstance.Name)

#copiar vídeos para a pasta de destino
foreach ($item in (ls $fileQuery -Recurse))
{
    $fileDest = "{0}\{1:yy-MM-dd}\{2} " -f $global:usbWatcherDestFolder,$item.LastWriteTime,$item.Name

    Write-Host $fileDest

    if(! (Test-Path $fileDest))
    {
        Write-Host "Copiando arquivo $item"
        copy-item $item.FullName $fileDest -Recurse -Force
    }
}


#$global:teste = $event.SourceEventArgs.NewEvent.TargetInstance.Name

#GET-WMIOBJECT win32_diskdrive | Where { $_.InterfaceType –eq ‘USB’ -and $_.SerialNumber -eq $event.SourceEventArgs.NewEvent.TargetInstance.VolumeSerialNumber }

write-host "SUA GOPRO ESTÁ PRONTA VIADÃO"