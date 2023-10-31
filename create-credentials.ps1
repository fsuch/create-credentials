param (
    [string]$resourceIdentifier,
    [string]$credentialDisplayName,
    [boolean]$forceReset = $false
)
$allCredentials = az ad app credential list --id $resourceIdentifier --output json | ConvertFrom-Json

$credential = $allCredentials | Where-Object {$_.displayName -eq $credentialDisplayName}

if ($credential)
{
    if (-Not $forceReset)
    {
        Write-Host "Credential with display name '$credentialDisplayName' already exists, exiting"
        return;
    }
    Write-Host "Credential with display name '$credentialDisplayName' already exists and force reset is true, deleting credential"
    az ad app credential delete --id $resourceIdentifier --key-id $credential.keyId
    Write-Host "Credential deleted"
}

Write-Host "Credential with display name '$credentialDisplayName' doesn't exist, creating it"
az ad app credential reset --id $resourceIdentifier --display-name $credentialDisplayName --append
