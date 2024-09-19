#will create scheduled task only for user who executes the scripts

$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-Command `"Set-TimeZone -Id 'India Standard Time'; w32tm /resync; [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; $template = [Windows.UI.Notifications.ToastTemplateType]::ToastText01; $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template); $text = $xml.GetElementsByTagName('text'); $text[0].AppendChild($xml.CreateTextNode('Time updated to IST successfully')); $toast = [Windows.UI.Notifications.ToastNotification]::new($xml); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('TimeUpdateTask').Show($toast)`""
#Action: Defines the task to set timezone to IST and resync time.
#Notification Command: Adds a PowerShell command to display a Windows notification after updating the time to IST.

$trigger = New-ScheduledTaskTrigger -AtLogOn
#Trigger: Sets the task to run at user logon.

$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
#Principal: Uses the logged-in user’s account with limited privileges.

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
#Settings: Configures task to run on battery power and start when available

Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "UpdateTimeTask" -Description "Sets timezone to IST and updates system time after logon"
#Register Task: Creates the task with specified action, trigger, principal, and settings.