# Requires SharePoint Online Management Shell and SharePoint SDK installed:
# http://technet.microsoft.com/en-us/library/fp161372(v=office.15).aspx
# http://www.microsoft.com/en-us/download/details.aspx?id=30722
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"   
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

## SETUP/LOGIN INFO
$siteUrl = "https://myoffice365site.sharepoint.com/siteURL"
$username = "username@myoffice365site.com"
$password = Read-Host -Prompt "Enter password:" -AsSecureString

## SITES/SUBSITES CLEANUP

    # create context, create site object
    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)     
    $ctx.Credentials= New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password)  

    # sites/subsites to keep
    $keepSites = (
    )

    # remove sites/subsites
    # this removes subsites of subsites

## GROUPS CLEANUP

    # connect
    #$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, 
    #    $(convertto-securestring $password -asplaintext -force)
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $password
    Connect-SPOService -Url "https://myoffice365site-admin.sharepoint.com" -credential $cred
    $site = Get-SPOSite $siteUrl

    # groups to keep
    $keepGroups = (
	    "Approvers", "Designers", "Company Administrator", "Hierarchy Managers", "NT AUTHORITY\authenticated users",
	    "Everyone","Everyone except external users", "Excel Services Viewers")


    # confirm total groups
    $spGroups = Get-SPOSiteGroup -Site $site
    Write-Host "This site has" $spGroups.Count "groups"

    # remove what we're keeping from list
    $groups = $spGroups | ? {$_.Title -notin $keepGroups}
    Write-Host "Found" $groups.Count "groups which will be deleted:"

    # remove groups
    ForEach($group in $groups) {
       Write-Host "Deleting" $group.Title "..."
       #Remove-SPOSiteGroup -Site $site -Identity $group.Title
    }