# Define Parameters
Param(
  [parameter(mandatory=$true)][String]$Description,
  [parameter(mandatory=$true)][String]$ScriptFile
)

# Get the path of the script file
$ScriptFilePath = Convert-Path $ScriptFile

# If the script file exists
if ( $ScriptFilePath -ne $null )
{
  # Get the full path of the script file
  $ScriptFileFullPath = Get-Command $ScriptFilePath | select $_.FullName

  # Create a self-signed certificate
  $Cert = New-SelfSignedCertificate `
    -Subject "CN=$Description, OU=Self-signed RootCA" `
    -KeyAlgorithm RSA `
    -KeyLength 4096 `
    -Type CodeSigningCert `
    -CertStoreLocation Cert:\CurrentUser\My\ `
    -NotAfter ([datetime]"2099/01/01")

  # Move the certificate to the root certificate store
  Move-Item "Cert:\CurrentUser\My\$($Cert.Thumbprint)" Cert:\CurrentUser\Root

  # Get the root certificate
  $RootCert = @(Get-ChildItem cert:\CurrentUser\Root -CodeSigningCert)[0]

  # Sign the script file
  Set-AuthenticodeSignature "Specified Directory" $RootCert
}
