$CriticalCapacity = 90

function Disk-Cleaner {

$GlobalDiskView = Get-WmiObject -Class Win32_LogicalDisk

	Foreach($Disk in $GlobalDiskView){
    $DiskSpace = ($Disk.Size/1GB).ToString('F0')
 		$DiskFreeSpace = ($Disk.freespace/1GB).ToString('F0')
   	$DeviceID = $Disk.DeviceID
    $DeviceName = $Disk.Name

    $SpaceDiskUsedPourcent = (100 - ((($Disk.FreeSpace/1GB) * 100)/($Disk.Size/1GB))).ToString('F0')

    Write-Host "disque $DeviceID :"
    Write-Host "	nom du disque : $DeviceName"
    Write-Host "	capatité disque : $SpaceDiskUsedPourcent%"

    If($SpaceDiskUsedPourcent -ge $CriticalCapacity)
    {
     	$CapacityState = "CRITICAL"
    } else {
      $CapacityState = "SAFE"
    }
    Write-Host "	état du disque : $CapacityState"
	  Write-Host "  "
	  
	}
}

Disk-Cleaner
