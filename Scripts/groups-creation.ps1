Import-Module ActiveDirectory

$groups = @(
    "HR_Readps",
    "Finance_Modifyps",
    "IT_Adminps",
    "Workstation_Usersps"
)

foreach ($g in $groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$g'" -ErrorAction SilentlyContinue)) {
        New-ADGroup `
            -Name $g `
            -GroupScope Global `
            -GroupCategory Security `
            -Path "OU=Groups,DC=corp,DC=local"
        Write-Host "Created group: $g"
    } else {
        Write-Host "Group already exists: $g"
    }
}
