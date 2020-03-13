function Get-sPOFolderFiles {
  param(
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Username,
    [Parameter(Mandatory = $true, Position = 2)]
    [string]$Url,
    [Parameter(Mandatory = $true, Position = 3)]
    [securestring]$password,
    [Parameter(Mandatory = $true, Position = 4)]
    [string]$ListTitle
  )

  $ctx = New-Object Microsoft.SharePoint.Client.ClientContext ($Url)
  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials ($Username, $password)
  $ctx.Load($ctx.Web)
  $ctx.ExecuteQuery()
  $ll = $ctx.Web.Lists.GetByTitle($ListTitle)
  $ctx.Load($ll)
  $ctx.ExecuteQuery()
  $spqQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
  $spqQuery.ViewXml = "<View Scope='RecursiveAll'><RowLimit>100</RowLimit></View>";

  do {
    $itemki = $ll.GetItems($spqQuery)
    $ctx.Load($itemki)
    $ctx.ExecuteQuery()

    foreach ($item in $itemki) {
      if ($item.FileSystemObjectType -eq 'Folder') {
        continue
      }
      $file = $ctx.Web.GetFileByServerRelativeUrl($item["FileRef"]);
      $ctx.Load($file)
      $ctx.Load($file.Versions)
      $ctx.ExecuteQuery()
      if ($file.Versions.Count -eq 0) {
        Write-Host "0 Versions (Passed)" $item["FileRef"]
      }
      else {
        $file.Versions.DeleteAll()

        try { 
          $ctx.ExecuteQuery()
          Write-Host $file.Versions.Count "Versions (Delete)" $item["FileRef"] -ForegroundColor Green
        }
        catch {
          Write-Host $file.Versions.Count "Versions (Failed)" $item["FileRef"] -ForegroundColor Red
        }
      }
    }
    $spqQuery.ListItemCollectionPosition = $itemki.ListItemCollectionPosition
  } while ($itemki.ListItemCollectionPosition)
}

#Paths to SDK
Add-Type -Path ".\Lib\Microsoft.SharePoint.Client.dll"
Add-Type -Path ".\Lib\Microsoft.SharePoint.Client.Runtime.dll"

#Enter the data
$Url = "https://TODO-my.sharepoint.com/personal/TODO_SITE_NAME"

$username = "TODO_USERNAME"
$AdminPassword = ConvertTo-SecureString -String "TODO_PASSWORD" -AsPlainText -Force
#$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString

#$ListTitle = "文档"
$ListTitle = "Documents"

Get-sPOFolderFiles -UserName $username -Url $Url -password $AdminPassword -ListTitle $ListTitle
