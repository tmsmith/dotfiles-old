#
# Start Windows Service on a Remote Machine
#
function Start-WinService([string] $server, [string] $serviceName) {
  $service = Get-Service -ComputerName $server -Name $serviceName
  if ($service.Status -like 'Running') {
    Write-Host "Service already running."  -ForegroundColor "Yellow"
    return $service.Status
  }

  $service.start()
  $service.WaitForStatus("StartPending", (new-timespan -seconds 10))
  Write-Host $service.Name is Starting
  $service.WaitForStatus("Running", (new-timespan -seconds 20))#>
  Write-Host $service.Name is $service.Status
  return $service.Status 
}

#
# Stop Windows Service on a Remote Machine
#
function Stop-WinService([string] $server, [string] $serviceName) {
  $service = Get-Service -ComputerName $server -Name $serviceName
  if ($service.acceptStop) {
    Throw "Service does not support stopping."
  }

  if ($service.Status -like 'Stopped') {
    Write-Host "Service already stopped."  -ForegroundColor "Yellow"
    return $service.Status
  }

  $service.Stop();
  $service.WaitForStatus("StopPending", (new-timespan -seconds 90))
  Write-Host $service.Name is Stopping
  $service.WaitForStatus("Stopped", (new-timespan -seconds 90))
  Write-Host $service.Name is $service.Status
  return $service.Status
}

#
# Check if server is available 
#
function Ping-Server ([string]$srv) {  
      $ping = new-object System.Net.Networkinformation.Ping  
      Trap {Continue} $pingresult = $ping.send($srv, 3000, [byte[]][char[]]"z"*16)  
      if($pingresult.Status -ieq "Success"){$true} else {$false}  
 }

#
# Return IPs for all interfaces
#
function Get-Ips() {
  $ent = [net.dns]::GetHostEntry([net.dns]::GetHostName())
  return $ent.AddressList | ?{ $_.ScopeId -ne 0 } | %{
    [string]$_
  }
}

#
# Escape HTML string
#
function Escape-Html($text) {
  $text = $text.Replace('&', '&amp;')
  $text = $text.Replace('"', '&quot;')
  $text = $text.Replace('<', '&lt;')
  $text.Replace('>', '&gt;')
}

#
# Convert From Base-64
#
function ConvertFrom-Base64([string] $string) {
  $bytes  = [System.Convert]::FromBase64String($string);
  $decoded = [System.Text.Encoding]::UTF8.GetString($bytes); 
  return $decoded;
}

#
# Convert To Base-64
#
function ConvertTo-Base64([string] $string) {
  $bytes  = [System.Text.Encoding]::UTF8.GetBytes($string);
  $encoded = [System.Convert]::ToBase64String($bytes); 
  return $encoded;
}

#
# Generate a new guid
#
function New-Guid {
  [guid]::NewGuid().toString('d')
}

#
# Hash a string
#
function Get-Hash($value, $algorithm = 'SHA256') {
  if ( $value -is [string] ) {
    $value = [text.encoding]::UTF8.GetBytes($value)
  }

  $algorithm = [security.cryptography.hashalgorithm]::Create($algorithm)
  $hash = $algorithm.ComputeHash($value);
  return [System.Convert]::ToBase64String($hash); 
}

#
# Get Seconds Since Epoch
#
function Get-UnixSeconds
{
  param(
    [DateTime] $datetime = (Get-Date)
   )

  [int]($datetime.ToUniversalTime() - ((Get-Date '1/1/1970'))).TotalSeconds
}

#
# Get Time from seconds based on Epoch
#
function Get-DateTimeFromUnixSeconds()
{
  param(
    [int] $timestamp
  )

  return ((Get-Date -Date '1/1/1970')).AddSeconds($timestamp);
}