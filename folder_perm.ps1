﻿$primaryuser = (Get-ItemProperty -path "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\DataStore\S-1-5-21-1725562737-1827328992-814387261-1001\0").'szName'
$apppath="C:\Program Files\Google\Chrome\Application\chrome.exe"
$currentuser= whoami
$foldepath="C:\WhatsApp Documents"

function setpermission ($folder,$groupname,$permissionlevel)
{
$acl = get-acl $folder
$accessrule= New-Object System.Security.AccessControl.FileSystemAccessRule($groupname,$permissionlevel,"Allow")
$acl.SetAccessRule($accessrule)
set-acl -path $folder -AclObject $acl
}

IF (test-path $apppath)
{
Write-host " $apppath is accessible" -ForegroundColor Green
if ($currentuser -eq $primaryuser)
{
Write-Host "Current user $currentuser is  Primary user ($primaryuser)" -ForegroundColor Green 
setpermission($foldepath,"Users","FullControl")
$acl=get-acl $foldepath
$folderowner=$acl.Owner
if($folderowner -eq $primaryuser)
{
Write-host "Primary User  $primaryuser is the owner of this folder " -ForegroundColor Green
}
else
{
Write-host "Owner of this folder $foldepath is $folderowner"
}
}
else
{
Write-Host "Current user $currentuser is not Primary user ($primaryuser)" -ForegroundColor Red
}
}

else
{
write-host "$apppath is not found or not accessible"
}



icacls.exe "C:\WhatsApp Documents"  /grant "Users:(OI)(CI)(RX)"
icacls "C:\WhatsApp Documents"



icacls "C:\WhatsApp Documents" /inheritance:d /t /c
icacls "C:\WhatsApp Documents" /remove:g Users /t /c
icacls "C:\WhatsApp Documents"