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
    [String]$ports,

    [string]$range,
    [string]$startip,
    [string]$endip,

    [string]$sport,
    [string]$eport,
    
    [int]$cidr

    )

if ($ip -match '-'){
    $range = $ip.split("-")
    return $range[0]
}



if ($ip -match '/'){
    $range = $ip.split("/")
    return $range
}

}