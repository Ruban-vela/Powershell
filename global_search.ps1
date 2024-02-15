$searchdirectories=(get-psdrive | where-object { $_.Root -match ":" } ).Root

$searchpattern = "Ruban"

foreach ( $directory in $searchdirectories ){

$files= Get-ChildItem -Path $directory -Recurse | Where-Object { $_.name -match $searchpattern} 
$files | Select-Object -Property Name,directory 
}