Import-Module ActiveDirectory

$defaultPassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

$users = @(
    @{Name="Alice HR"; Sam="alice.hr"; OU="OU=HR,OU=CorpUsers,DC=corp,DC=local"},
    @{Name="Bob HR"; Sam="bob.hr"; OU="OU=HR,OU=CorpUsers,DC=corp,DC=local"},
    @{Name="John IT"; Sam="john.it"; OU="OU=IT,OU=CorpUsers,DC=corp,DC=local"},
    @{Name="Susan IT"; Sam="susan.it"; OU="OU=IT,OU=CorpUsers,DC=corp,DC=local"},
    @{Name="Mark Finance"; Sam="mark.fin"; OU="OU=Finance,OU=CorpUsers,DC=corp,DC=local"},
    @{Name="Nina Finance"; Sam="nina.fin"; OU="OU=Finance,OU=CorpUsers,DC=corp,DC=local"}
)

foreach ($u in $users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($u.Sam)'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -Name $u.Name `
            -SamAccountName $u.Sam `
            -UserPrincipalName "$($u.Sam)@corp.local" `
            -Path $u.OU `
            -AccountPassword $defaultPassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true
        Write-Host "Created user: $($u.Sam)"
    } else {
        Write-Host "User already exists: $($u.Sam)"
    }
}
