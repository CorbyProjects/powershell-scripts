# 1. log in to do stuff
$cred = Get-Credential
Connect-MsolService -Credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber

# 2. Import-Csv -Path <Input CSV File Path and Name> | 
# foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName 
# -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId [-Password $_.Password]} 
# | Export-Csv -Path <Output CSV File Path and Name>

Import-Csv -Path "path\users.csv" | 
    foreach {New-MsolUser -DisplayName $_.DisplayName -UserPrincipalName $_.UserPrincipalName -UsageLocation "us" -LicenseAssignment $_.AccountSkuId -Password $_.Password -ForceChangePassword $FALSE} | 
    Write-Host "Added Users" #Export-Csv -Path "path\NewAccountResults.csv"

#$checkIfMailboxExists = Get-Mailbox -ResultSize Unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox')} $users -erroraction silentlycontinue
do {
        $users = Get-Mailbox -ResultSize Unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox')} $users -erroraction silentlycontinue
        Write-Host "Checking if mailbox has been created yet"
        Start-Sleep -Seconds 30
}
While ($users -eq $Null)

ForEach ($user in $users) {

    Set-MailboxRegionalConfiguration -Identity $user.Identity -Language "en-us"  -TimeZone "Eastern Standard Time"
}

Read-Host "All finished, press ENTER to let script end."