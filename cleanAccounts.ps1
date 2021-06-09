## one way ##
# 1. delete user in portal
# 2. log in to exch to do stuff
$cred=Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session
# 3. force delete
Remove-Mailbox -Identity username@myoffice365site.com -Permanent $true
# 4. create account again in portal

## another way ##
# 1. create shared mailbox
# 2. log in to exch to do stuff
#$cred=Get-Credential
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
#Import-PSSession $Session
# 3. move mail contents to shared mailbox
#Search-Mailbox -Identity alias@domain.com -DeleteContent -TargetMailbox sharedmailbox@domain.cm 