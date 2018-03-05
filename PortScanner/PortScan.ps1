###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  PortScan.ps1 
# Autor        :  Bill Krodthoff
# Description  :  Port Scanner
###############################################################################################################

<#
    .SYNOPSIS
    This script helps scan a range of Ip addresses for open ports

    .DESCRIPTION
    This script will accept a range of ports and addresses as it scans. This easily shows the information of
    the ports, whether they are open or closed per address.

    .EXAMPLE
    .\PortScan.ps1 


#>

function leedle
{

[CmdletBinding()]
param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        HelpMessage='IPv4-Address range of devices to port scan')]
    [String]$ip,

    [Parameter(
        Position=1,
        Mandatory=$true,
        HelpMessage='Range of Ports to check. Default 1-65535')]
    [Array]$ports,

    [string]$startip,
    [string]$endip,

    [Int32]$sport,
    [Int32]$eport,
    
    [Int32]$cidr

    )

#Check and separate the input for Ip Addresses
if ($ip -match '-'){
    $range = $ip.split("-")

    #$startip = [Net.IPAddress]::Parse($range[0]).GetAddressBytes()
    #[array]::Reverse($startip)
    #$startip = ([Net.IPAddress]($startip -join '.')).Address
    
    #return $startip = [system.BitConverter]::ToUInt32($startip, 0)
    
    #$endip = [Net.IPAddress]::Parse($range[1]).GetAddressBytes()
    #[array]::Reverse($endip)
    #$endip = ([Net.IPAddress]($endip -join '.')).Address
    #$endip = [system.BitConverter]::ToUInt32($endip, 0)
    
    $s1 = ($range[0].Split(' ') -join '.')
    $s2 = ($range[1].Split(' ') -join '.')
    
    $begin = ([System.Net.IPAddress]$s1).GetAddressBytes()
    [Array]::Reverse($begin)
    $begin = ([Net.IPAddress]($begin -join '.')).Address
    
    $end = ([Net.IPAddress]$s2).GetAddressBytes()
    [Array]::Reverse($end)
    $end = ([Net.IPAddress]($end -join '.')).Address

    $array = @()

    for ($x=$begin; $x -le $end; $x++) {
        $test = ([System.Net.IPAddress]$x).GetAddressBytes()
        [Array]::Reverse($test)
        $test = $test -join '.'

        $object = New-Object -TypeName PSObject
        $object | Add-Member -Name 'IP Address' -MemberType Noteproperty -Value $test

        $array += $object
    }

    

    
}Elseif($ip -match '/'){
    $range = $ip.split("/")
    $startip = [System.Net.IPAddress]::Parse($range[0])
    $cidr = $range[1]
    }


#Check and separate the input for the ports
 $PortsArray = @()
 foreach($b in $ports){
    Write-Output $b 
    
    #Checks list of ports
    if($b -lt 1 -XOR $b -gt 65535){
        return {Invalid list of ports}
        }
    
    #If item is a range, will split and check
    if($b -match '-'){
        $portRange = $b.Split('-')
        $sport = $portRange[0]
        $eport = $portRange[1]
        
        #Returns an error message for improper ports
        if($sport -gt $eport -XOR $sport -lt 1 -XOR $eport -gt 65535){
            return {Invalid Range of ports}
            }

        for($i=$sport; $i -le $eport; $i++){
            if(-Not $PortsArray.Contains($i)){
                $PortsArray += $i
                }
            }
        
        }Elseif(-Not $PortsArray.Contains($b)){
        $PortsArray += $b
        }
    }

####################################$PortsArray


foreach($test in $addresses){
    
    

    $object = New-Object -TypeName PSObject
    $object | Add-Member -Name 'IP Address' -MemberType Noteproperty -Value $ip
    $object | Add-Member -Name 'Open Ports' -MemberType Noteproperty -Value $open
    $object | Add-Member -Name 'Closed Ports' -MemberType Noteproperty -Value $closed

    $array += $object
    }

try{
    $socket = New-Object System.Net.Sockets.TcpClient($cIP, $cPort)
    
    if($socket.Connected){
        "$cIP port $cPort open"
        $socket.Close()
    }else{
        "$cIP port $cPort closed"
        }

    }
catch{$status = "Closed"}

}