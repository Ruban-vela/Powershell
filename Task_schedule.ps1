# Load necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Scheduled Task Starter"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(260,20)
$label.Text = "Enter the name of the scheduled task:"
$form.Controls.Add($label)

# Create a textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,50)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,80)
$button.Size = New-Object System.Drawing.Size(260,30)
$button.Text = "Start Task"
$form.Controls.Add($button)

# Button click event
$button.Add_Click({
    $taskName = $textBox.Text
    if ([string]::IsNullOrWhiteSpace($taskName)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a task name.", "Error")
    } else {
        try {
            Start-ScheduledTask -TaskName $taskName
            [System.Windows.Forms.MessageBox]::Show("Scheduled task started successfully.", "Success")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to start the scheduled task. Error: $_", "Error")
        }
    }
})

# Run the form
[void]$form.ShowDialog()
