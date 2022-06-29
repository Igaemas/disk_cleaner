$CriticalCapacity = 90


function Get-Disk-Info {

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
		
		  Get-User-Input
	  }
}

function Get-User-Input {
	$UserInput = Read-Host -Prompt 'voulez-vous procéder au nettoyage basique ? (y/n) : '
	if(($UserInput -eq "y") -or ($UserInput -eq "yes") -or ($UserInput -eq "oui"))
	{
		Write-Host "c'est un oui"
	} elseif(($UserInput -eq "n") -or ($UserInput -eq "no") -or ($UserInput -eq "non"))
	{
		Write-Host "ah bah non"
	} else {
		Get-User-Input
	}
}


Get-Disk-Info
