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
    .\PortScan.ps1 192.168.1.1-192.168.1.5 20,80


#>

function PortScan
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

        #$object = New-Object -TypeName PSObject
        #$object | Add-Member -Name 'IP Address' -MemberType Noteproperty -Value $test

        #$array += $object
        $array +=$test
    }

    
    

    
}Elseif($ip -match '/'){
    $range = $ip.split("/")
    
    $s1 = ($range[0].Split(' ') -join '.')
    $cidr = $range[1]

    $begin = ([System.Net.IPAddress]$s1).GetAddressBytes()
    [Array]::Reverse($begin)
    $begin = ([Net.IPAddress]($begin -join '.')).Address
    
    [int64]$int = [convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)
    $netmask = (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )

    $cause = ([System.Net.IPAddress]$int).GetAddressBytes()
    [Array]::Reverse($cause)
    $cause = $cause -join '.'
        
        
    $intend = (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $cause.address -bor $netmask.address)) 
    $endmask = (([math]::truncate($intend/16777216)).tostring()+"."+([math]::truncate(($intend%16777216)/65536)).tostring()+"."+([math]::truncate(($intend%65536)/256)).tostring()+"."+([math]::truncate($intend%256)).tostring() )
    
     
    
    #$networkaddr = new-object net.ipaddress ($maskaddr.address -band $begin.address)

    $array = @()
    $x3 = ($int -band $begin)    
    $count=$x3+($intend-$int)
    for ($x=$x3; $x -le $count; $x++) {
                
        $test = ([System.Net.IPAddress]$x).GetAddressBytes()
        [Array]::Reverse($test)
        $test = $test -join '.'
        #Write-Output $x3
        $array +=$test
        }
    }
    


#Check and separate the input for the ports
 $PortsArray = @()
 
 foreach($b in $ports){

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
        }else{
            #Checks list of ports
            if($b -lt 1 -XOR $b -gt 65535){
                $b
                return {Invalid list of ports}
                }
    
            }      
    }



$results = @()
$open = @()
$closed = @()

$x1=0
foreach($address in $array){
    
    foreach($cPort in $PortsArray){
        $x1 = $x1+1
        Write-Progress “Scanning ”$address':'$cPort -PercentComplete (($x1/($array.Count*$PortsArray.Count))*100)

        $object = New-Object -TypeName PSObject
        $object | Add-Member -Name 'IP' -MemberType Noteproperty -Value $address

        
        $socket = New-Object System.Net.Sockets.TcpClient($cIP, $cPort)
    
        if($socket.Connected){
            if(-Not $open.Contains($cPort)){
                $open += $cPort               
                    }
            $socket.Close()
        }else{
            if(-Not $closed.Contains($cPort)){
                $closed += $cPort               
                }
            }
        }
        $object | Add-Member -Name 'OP' -MemberType Noteproperty -Value $open
        $object | Add-Member -Name 'CP' -MemberType Noteproperty -Value $closed
        $results += $object
    }
    

    #$lol
    #Select $results.Members type 
    #$results | Select-Object -Property 'IP Address'={$_.IP},'Open Ports'={$_.OP},'Closed Ports'={$_.CP}
    $results | Select @{Name="IP Address";Expression={$_.IP}}, @{Name="Open Ports";Expression={$_.OP}}, @{Name="Closed Ports";Expression={$_.CP}}  #Export-Csv –Path P:\PortScan.csv
}