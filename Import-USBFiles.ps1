Write-Host "RECONHECENDO SEU USB!"

if((! $global:usbWatcherDestFolder) -or (! (Test-Path $global:usbWatcherDestFolder)))
    { Write-Error "Variável global `$usbWatcherDestFolder não encontrada. Verifique se ela está sendo setada no arquivo ps-usb-watcher.profile.ps1 corretamente ou execute o script novamente." }

#TODO falta validar se o drive é da gopro. gastei um tempão procurando e ainda não achei.

$fileQuery = ("{0}\*.mp4" -f $event.SourceEventArgs.NewEvent.TargetInstance.Name)

write-host $file

try
{
    $i = 0
    $Script:files = (ls $fileQuery -Recurse)
    #copiar vídeos para a pasta de destino
    foreach ($item in $Script:files)
    {
        $Script:from = $item.Name
        $fileDest = "{0}\{1:yy-MM-dd}\{2}" -f $global:usbWatcherDestFolder,$item.LastWriteTime,$item.Name

        write-progress -activity "Copiando arquivos:" -status "Arquivo: $Script:from" -percentcomplete ($i/$files.count*100)    

        if(! (Test-Path $fileDest))
        {
            Write-Host "Copiando arquivo $item"
            New-Item -Force (split-path $fileDest -parent) -ItemType directory
            copy-item $item.FullName $fileDest -Force
        }

        $i = $i+1;
    }
}
catch [System.Exception]
{
    Write-Host $_.Exception.Message
}


#GET-WMIOBJECT win32_diskdrive | Where { $_.InterfaceType –eq ‘USB’ -and $_.SerialNumber -eq $event.SourceEventArgs.NewEvent.TargetInstance.VolumeSerialNumber }

write-host "SUA GOPRO ESTÁ PRONTA VIADÃO"