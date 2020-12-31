**Use `rclone cleanup OneDrive:/path` better new since rclone v1.52.**
**And this project is deprecated and archived since now**


# OneDrive VersionHistory Cleaner

MOD of PowerShell Script from [Delete all previous file versions in a library](https://gallery.technet.microsoft.com/office/Delete-all-previous-file-fd1ba18a) by Rhilip.

**!!! Notice All Version History will remove without confirm and no Recovery bin used !!!**

## Edit those lines Before Run

```powershell
#Enter the data
$Url = "https://TODO-my.sharepoint.com/personal/TODO_SITE_NAME"

$username = "TODO_USERNAME"
$AdminPassword = ConvertTo-SecureString -String "TODO_PASSWORD" -AsPlainText -Force
#$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString

#$ListTitle = "文档"
$ListTitle="Documents"
```





