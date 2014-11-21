param([switch]$WhatIf = $false)
#adaptado do script install.ps1 do posh-git

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent

if(!(Test-Path $PROFILE)) {
    Write-Host "Creating PowerShell profile...`n$PROFILE"
    New-Item $PROFILE -Force -Type File -ErrorAction Stop -WhatIf:$WhatIf > $null
}

# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

$profileLine = ". '$installDir\ps-usb-watcher.profile.ps1'"
if(Select-String -Path $PROFILE -Pattern $profileLine -Quiet -SimpleMatch) {
    Write-Host "It seems ps-usb-watcher is already installed..."
    return
}

Write-Host "Adding posh-git to profile..."
Get-FileEncoding $PROFILE
@"

# Load ps-usb-watcher example profile
$profileLine
"@ | Out-File $PROFILE -Append -WhatIf:$WhatIf -Encoding (Get-FileEncoding $PROFILE)

Write-Host 'ps-usb-watcher sucessfully installed!'
Write-Host 'Please reload your profile for the changes to take effect:'
Write-Host '    . $PROFILE'