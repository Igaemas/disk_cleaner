$CriticalCapacity = 90

function Disk-Cleaner {

  $GlobalDiskView = Get-WmiObject -Class Win32_LogicalDisk

	$DiskListArray = @()


    Foreach($Disk in $GlobalDiskView){
      $DiskSpace = [math]::Round(($Disk.Size/1GB))
 		  $DiskFreeSpace = [math]::Round(($Disk.freespace/1GB))
   	  $DeviceID = $Disk.DeviceID
      $DeviceName = $Disk.Name
      $DriveLetter = $DeviceID.Substring(0,$DeviceID.Length-1)
    
      $SpaceDiskUsedPourcent = [math]::Round((100 - ((($Disk.FreeSpace/1GB) * 100)/($Disk.Size/1GB))))

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
	  
      $DiskListArray += $DriveLetter
      Write-Host $DiskListArray
    }
  write-host "Supression des Recycle.Bin"
  write-host $DiskListArray
  foreach($DiskLetter in $DiskListArray){
	  Clear-RecycleBin -Force -DriveLetter $DiskLetter
    Get-ChildItem "$DeviceID\Windows\SoftwareDistribution\Download\" 
    #| Remove-Item -recurse -force
    Get-ChildItem "$DeviceID\Windows\Temp\"
    #| Remove-Item -recurse -force
  }
}

Disk-Cleaner
