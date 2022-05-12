
#-------------------------------------------------------------#
#----Initial Declarations-------------------------------------#
#-------------------------------------------------------------#

Add-Type -AssemblyName PresentationCore, PresentationFramework

$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="350" Height="200">
<Grid Margin="11,3,-11,-3">
 <Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="HANSENBERG IT-Toolkit" Margin="8,8,0,0" Name="Title" FontSize="24" FontWeight="Bold"/>
 <Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Backup" Margin="8,40,0,0" FontSize="20"/>
 <Button Content="Opret backup" HorizontalAlignment="Left" VerticalAlignment="Top" Width="100" Margin="13,80,0,0" Name="createBackupBTN"/>
 <Button Content="Gendan backup" HorizontalAlignment="Left" VerticalAlignment="Top" Width="100" Margin="120,80,0,0" Name="restoreBackupBTN"/>
</Grid>
</Window>
"@

#-------------------------------------------------------------#
#----Control Event Handlers-----------------------------------#
#-------------------------------------------------------------#


#region Backup

function createBackup() {
    $c = Get-Credential
    $Username = $c.Username    
    
    # Pre-Checks
    
    $OneDriveTest = Test-Path -Path "C:\Users\$Username\OneDrive\Skrivebord"
    
    if ($OneDriveTest -ne "True") {
        msg * /server:127.0.0.1 "Slå venglist sync til for skrivebordet"
        Break 
    }
    
    $BackupPath = "C:\Users\$Username\OneDrive\Skrivebord\Backup-$Username"

    mkdir $BackupPath\StickyNotes
    mkdir $BackupPath\Chrome
    mkdir $BackupPath\Edge
    
    Copy-Item "C:\Users\$Username\AppData\Local\Google\Chrome\User Data\Default\*Bookmarks*" $BackupPath\Chrome\Bookmarks
    Copy-Item "C:\Users\$Username\AppData\Local\Microsoft\Edge\User Data\Default\*Bookmarks*" $BackupPath\Edge\Bookmarks
    Copy-Item -R "C:\Users\$Username\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\*" $BackupPath\StickyNotes
    
    msg * /server:127.0.0.1 "Backup oprettet, tjek venligst om alt er iorden."
}

function restoreBackup() {
    $c = Get-Credential
    $Username = $c.Username

    # Pre-Checks
    
    $OneDriveTest = Test-Path -Path "C:\Users\$Username\OneDrive\Skrivebord"
    
    if ($OneDriveTest -ne "True") {
        msg * /server:127.0.0.1 "Slå venglist sync til for skrivebordet"
        Break 
    }
    
    $BackupPath = "C:\Users\$Username\OneDrive\Skrivebord\Backup-$Username"

    Copy-Item $BackupPath\Chrome\*Bookmarks* "C:\Users\$Username\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    Copy-Item $BackupPath\Edge\*Bookmarks* "C:\Users\$Username\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
    Copy-Item -R $BackupPath\StickyNotes\* "C:\Users\$Username\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\"
    
    msg * /server:127.0.0.1 "Genddannelse udført, tjek venligst om alt er iorden."
}

#endregion 


#-------------------------------------------------------------#
#----Script Execution-----------------------------------------#
#-------------------------------------------------------------#

$Window = [Windows.Markup.XamlReader]::Parse($Xaml)

[xml]$xml = $Xaml

$xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }


$createBackupBTN.Add_Click({createBackup $this $_})
$restoreBackupBTN.Add_Click({restoreBackup $this $_})

$Window.ShowDialog()


