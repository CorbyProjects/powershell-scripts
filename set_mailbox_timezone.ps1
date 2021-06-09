# 1. log in to do stuff
$cred = Get-Credential
Connect-MsolService –Credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session -AllowClobber


$Users = Get-Mailbox –ResultSize Unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox')} $users | %{Set-MailboxRegionalConfiguration $_.Identity -Language "en-US"  -TimeZone "Eastern Standard Time"}