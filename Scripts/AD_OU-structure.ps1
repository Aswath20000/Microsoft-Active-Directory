Import-Module ActiveDirectory

$baseDN = "DC=corp,DC=local"

function Ensure-OU {
    param (
        [string]$Name,
        [string]$Path
    )

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $Path -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $Path
        Write-Host "Created OU: $Name"
    } else {
        Write-Host "OU already exists: $Name"
    }
}

# Top-level OUs (NOTE: NO 'Users')
$topOUs = @("Admins","Servers","Workstations","CorpUsers","Groups")

foreach ($ou in $topOUs) {
    Ensure-OU -Name $ou -Path $baseDN
}

# Sub-OUs under CorpUsers
$userSubOUs = @("HR","IT","Finance")

foreach ($ou in $userSubOUs) {
    Ensure-OU -Name $ou -Path "OU=CorpUsers,$baseDN"
}
