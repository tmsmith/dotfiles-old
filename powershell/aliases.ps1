#
# Sublime Text 2
#
Set-Alias subl 'sublime_text.exe'
function st { subl $args }
function stt { subl . $args}


#
# Project shortcuts
#
function cdst { Set-Location "C:\Projects\Realm\Stratus" }
function cdrel { Set-Location "C:\Projects\Realm" }
function cdpay { Set-Location "C:\Projects\Payments" }
function cdnu { Set-Location "C:\Projects\Nuget" }
function cdm { Set-Location "Z:\" }


#
# Sanity
#
Set-Alias ll Get-ChildItem
Set-Alias open Invoke-Item

function touch { Set-Content -Path ($args[0]) -Value ($null) }

function x { exit }

#
# Edit Profile
#
function Edit-Profile {   
  st $dotfiles
}

Set-Alias ep Edit-Profile