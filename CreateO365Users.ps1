# log in to do stuff
$cred = Get-Credential
Connect-MsolService –Credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session -AllowClobber

###########################################
# UPDATE INFO THAT CHANGES ACROSS CLASSES #
###########################################
$date = "032119"
$numOfStudents = 22 #max = 23 bc of licensing
# to randomize passwords:
$sometext1 = "sometexthere"
$sometext2 = "sometexthere"

##########################################################
# YOU SHOULDN'T HAVE TO CHANGE ANYTHING BELOW THIS POINT #
##########################################################

# create trainer account, but only if they don't exist yet
$tupn = "Trainer@companyname"+$date+".onmicrosoft.com"
$tLA = "companyname"+$date+":ENTERPRISEPACK"
$tPassword = $sometext1+$date+$sometext2
$tMessage = "Added Trainer: Trainer@companyname"+$date+".onmicrosoft.com"

New-MsolUser -DisplayName "Trainer" -UserPrincipalName $tupn -UsageLocation "us" -LicenseAssignment $tLA -Password $tPassword -ForceChangePassword $FALSE
Write-Host $tMessage -ForegroundColor Green -BackgroundColor Black

# create student accounts
For ($i=1; $i -le $numOfStudents; $i++) {

    $supn = "Student"+$i+"@companyname"+$date+".onmicrosoft.com"
    $sdname = "Student"+$i
    $sLA = "companyname"+$date+":ENTERPRISEPACK"
    $sPassword = $sometext1+$date+$sometext2
    $sMessage = "Added User: Student"+$i+"@companyname"+$date+".onmicrosoft.com"

    New-MsolUser -DisplayName $sdname -UserPrincipalName $supn -UsageLocation "us" -LicenseAssignment $sLA -Password $sPassword -ForceChangePassword $FALSE
    Write-Host $sMessage -ForegroundColor Green -BackgroundColor Black
}

# wait for accounts to be made, then get all user accounts
# might have to rerun this last part if not all accounts picked up
Do {
        Start-Sleep -Seconds 120 #hopefully enough time for all accounts to be findable
        $users = Get-Mailbox –ResultSize Unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox')}
        Write-Host "Checking if mailbox has been created yet" -ForegroundColor Green -BackgroundColor Black
}
While ($users -eq 1)

#  set language & time zone for each user
ForEach ($user in $users) {
    $mbMessage = "Set configuration for "+ $user.UserPrincipalName
    
    Set-MailboxRegionalConfiguration -Identity $user.UserPrincipalName -Language "en-us"  -TimeZone "Eastern Standard Time"
    Write-Host $mbMessage -ForegroundColor Green -BackgroundColor Black
    ## TODO
    ## add get mailboxregionalconfig & check timezone, if not eastern, wait & repeat
}

#Read-Host "All finished, press ENTER to let script end"