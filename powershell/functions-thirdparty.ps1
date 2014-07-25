#
# Interact with a service on a remote TCP port
# http://brianreiter.org/2011/06/08/cool-powershell-script-replicates-telnet/
#
function Connect-Computer {
  param(
    [string] $remoteHost = "localhost",
    [int] $port = 6379
     )
 
  try
  {
      ## Open the socket, and connect to the computer on the specified port
      write-host "Connecting to $remoteHost on port $port"
      $socket = new-object System.Net.Sockets.TcpClient($remoteHost, $port)
      if($socket -eq $null) { return; }
   
      $stream = $socket.GetStream()
      $writer = new-object System.IO.StreamWriter($stream)
   
      $buffer = new-object System.Byte[] 1024
      $encoding = new-object System.Text.AsciiEncoding
   
      while($true)
      {
         ## Allow data to buffer for a bit
         start-sleep -m 500
   
         ## Read all the data available from the stream, writing it to the
         ## screen when done.
         while($stream.DataAvailable) 
         { 
            $read = $stream.Read($buffer, 0, 1024)   
            write-host -n ($encoding.GetString($buffer, 0, $read)) 
         }
   
         ## Read the user's command, quitting if they hit ^D
         write-host -n '>'
         $command = read-host
         
         ## Write their command to the remote host     
         $writer.WriteLine($command)
         $writer.Flush()
      }
  }
  finally
  {
      ## Close the streams
      $writer.Close()
      $stream.Close()
  }
}



<#
  .SYNOPSIS
  Gets file encoding.
  .DESCRIPTION
  The Get-FileEncoding function determines encoding by looking at Byte Order Mark (BOM).
  Based on port of C# code from http://www.west-wind.com/Weblog/posts/197245.aspx
  .EXAMPLE
  Get-ChildItem  *.ps1 | select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | where {$_.Encoding -ne 'ASCII'}
  This command gets ps1 files in current directory where encoding is not ASCII
  .EXAMPLE
  Get-ChildItem  *.ps1 | select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | where {$_.Encoding -ne 'ASCII'} | foreach {(get-content $_.FullName) | set-content $_.FullName -Encoding ASCII}
  Same as previous example but fixes encoding using set-content
#>
function Get-FileEncoding
{
    [CmdletBinding()] Param (
     [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] [string]$Path
    )

    [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path

    if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
    { Write-Output 'UTF8' }
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
    { Write-Output 'Unicode' }
    elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
    { Write-Output 'UTF32' }
    elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76)
    { Write-Output 'UTF7'}
    else
    { Write-Output 'ASCII' }
}