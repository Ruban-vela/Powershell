Add-Type -AssemblyName PresentationFramework

# Load the XAML file
[xml]$xaml = Get-Content "C:\path\to\your\TaskManager.xaml"
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Event to run task
$Window.FindName('RunTask').Add_Click({
    $servers = $Window.FindName('ServersInput').Text -split ","
    $task = $Window.FindName('TaskSelection').SelectedItem.Content
    
    $outputBox = $Window.FindName('Output')
    $outputBox.Clear()

    foreach ($server in $servers) {
        $result = ""
        switch ($task) {
            "Check Uptime" {
                $result = Invoke-Command -ComputerName $server -ScriptBlock { (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime }
            }
            "Ping Servers" {
                $result = Test-Connection -ComputerName $server -Count 1
            }
            "Service Status" {
                $result = Invoke-Command -ComputerName $server -ScriptBlock { Get-Service -Name 'NetBackup' }
            }
            "Disk Space" {
                $result = Invoke-Command -ComputerName $server -ScriptBlock { Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free }
            }
        }
        $outputBox.AppendText("Server: $server`nResult: $result`n`n")
    }
})

$Window.ShowDialog() | Out-Null
