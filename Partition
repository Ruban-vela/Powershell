Disable Recovery Environment and Delete Recovery Partition

$diskpartScript = @" list disk select disk 0 list partition "@

Run diskpart and store output

$output = diskpart /s "$diskpartScript" | Out-String

Extract Recovery Partition details

$partitionInfo = $output | Select-String -Pattern "Recovery" if ($partitionInfo) { $recoveryPart = ($partitionInfo -split " ")[1] $partitionType = ($partitionInfo -split " ")[3] $partitionAttributes = ($partitionInfo -split " ")[4]

# Disable Windows Recovery Environment
reagentc /disable

# Delete Recovery Partition
$deletePartition = @"

select disk 0 select partition $recoveryPart delete partition override list partition "@ diskpart /s "$deletePartition" }

Extend C Drive leaving 1GB unallocated

$extendCDrive = @" select disk 0 select partition 2 extend size=$((Get-PartitionSupportedSize -DriveLetter C).SizeMax - 1GB) "@ diskpart /s "$extendCDrive"

Recreate Recovery Partition

$createPartition = @" select disk 0 create partition primary size=650 id=$partitionType list partition select partition 4 detail partition format fs=ntfs quick label=WinRE set id=$partitionType gpt attributes=$partitionAttributes assign letter=Z detail partition "@ diskpart /s "$createPartition"

Enable Windows Recovery Environment

reagentc /enable

Unmount Z Drive

$unmountZ = @" select volume Z remove "@ diskpart /s "$unmountZ"
