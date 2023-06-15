# This script is intended to determine on wich disk your Windows OS should be installed
# The script works as followed --> preferably ssd, the bigger the best if no ssd use biggest hdd 
# Does nothing on it's own, must be used with something else like Microsoft Deployment Toolkit

$disks = Get-WmiObject -Class MSFT_PhysicalDisk -Namespace root\Microsoft\Windows\Storage | select-object deviceId, mediaType, Size # Check disks properties
$nbDisk = (get-disk | Where-Object { $_.Size -lt 100000GB }).Number.Count # Returns the number of disks : integer ## The disk number comes from BIOS order
$maxDiskSize = 0
$i = -1
$c = -1
$ssdList = New-Object 'object[,]' $nbDisk, 3 # Array to track ssd caracteristics
$hddList = New-Object 'object[,]' $nbDisk, 3 # Array to track hdd caracteristics
$ssd = $false # Boolean to track presence of SSDs on the system

foreach($disk in $disks)
{
    if($disk.mediaType -like "4") # Check if mediatype match ssd
    {
        $i ++
        $ssd = $true # Track ssd presence
        $ssdList[$i,0] = $disk.deviceId
        $ssdList[$i,1] = $disk.size
    }
    if($disk.mediaType -like "3") # Check if mediatype match hdd
    {
        $c ++
        $hddList[$c,0] = $disk.deviceId
        $hddList[$c,1] = $disk.size
    }
}

if($nbDisk -eq 1)
{
    $goodDisk = $disks.deviceI
    $maxDiskSize = $disks.Size
    # write-host "log : disk eq 1" ## Used for debug purposes
}
else
{
    $i = -1
    if($ssd -eq $true)
    {
        while($i -lt $nbDisk-1)
        {
            $i ++
            if($ssdList[$i,1] -gt $maxDiskSize)
                {
                    $maxDiskSize = $ssdList[$i,1] # Determine max disk capacity
                    $goodDisk = $ssdList[$i,0] # Used to select wich disk will be set as "best"
                    # Write-Host "log : ssd -eq True" ## Used for debug purposes
                }
        }
        Write-Host "The best ssd option is the disk number $goodDisk"
    }  
    else
    {
        $c = -1
        while($c -lt $nbDisk)
        {
            $c ++
            if($hddList[$c,1] -gt $maxDiskSize)
            {
                $maxDiskSize = $hddList[$c,1] # Determine max disk capacity
                $goodDisk = $hddList[$c,0] # Used to select wich disk will be set as "best"
                Write-Host "The best hdd option is the disk number $goodDisk" # This line may be commented it's here for logging only
            }
        }
    }
}

Write-host "best disk size : " $maxDiskSize
# Write-Host $ssdList ## Again this is for debug
# Write-Host $hddList ## Same as previous line
return $goodDisk
