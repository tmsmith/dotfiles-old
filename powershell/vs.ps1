
pushd ((Get-Item "Env:ProgramFiles(x86)").Value + "\Microsoft Visual Studio 11.0\VC")
cmd /c "vcvarsall.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
write-host "`nVisual Studio 2012 Command Prompt variables set." -ForegroundColor Yellow