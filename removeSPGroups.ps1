$siteUrl = "https://myoffice365site.sharepoint.com/sites/sitename"
$keep = (
	"Approvers", "Designers", "Company Administrator", "Hierarchy Managers", "NT AUTHORITY\authenticated users",
	"Everyone","Everyone except external users", "Excel Services Viewers")

Connect-SPOService -Url "https://myoffice365site-admin.sharepoint.com"
$site = Get-SPOSite $siteUrl

$spGroups = Get-SPOSiteGroup -Site $site
Write-Host "This site has" $spGroups.Count "groups"

#$groups = $spGroups | ? {$_.Title -notin $keep -or $_.Title -notlike "company name*" -or $_.Title -notlike "other company name*"}
$groups = $spGroups | ? {$_.Title -notin $keep}
Write-Host "Found" $groups.Count "groups which will be deleted:"

ForEach($group in $groups) {
   Write-Host "Deleting" $group.Title "..."
   Remove-SPOSiteGroup -Site $site -Identity $group.Title
}
