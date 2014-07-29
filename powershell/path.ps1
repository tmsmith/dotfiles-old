#
# Local helper to append to the env PATH
#
function script:append-path([string] $path) {
  if ( -not [string]::IsNullOrEmpty($path) ) {
    if ( (test-path $path) -and (-not $env:PATH.contains($path)) ) {
      $env:PATH += ';' + $path
    }
  }
}

#
# Append PATH with useful directories
#
append-path (join-path (Get-Item "Env:ProgramFiles").Value "Sublime Text 3")
append-path "$($env:WINDIR)\system32\inetsrv"
append-path (join-path (Get-Item "Env:ProgramFiles(x86)").Value "Git\bin")