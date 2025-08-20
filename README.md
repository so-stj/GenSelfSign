# GeneSelfSign PowerShell Script

A PowerShell script for generating self-signed certificates and applying code signing to scripts or executables.

##　Language

For Japanese README is [here](https://github.com/so-stj/GenSelfSign/blob/main/README_JP.md)

## Description

This script creates a self-signed code signing certificate and applies it to a specified file or directory. It's useful for development, automating and testing scenarios where you need to sign PowerShell scripts or other executables with a trusted certificate.

## Features

- Creates a self-signed code signing certificate with RSA 4096-bit encryption
- Automatically moves the certificate to the trusted root store
- Applies Authenticode signature to the specified target
- Certificate valid until January 1, 2099

## Prerequisites

- Windows PowerShell 5.1 or PowerShell Core 6.0+
- Administrative privileges (for certificate operations)
- Execution policy that allows running scripts

## Usage

```powershell
.\GeneSelfSign.ps1 -Description "Your Certificate Description" -ScriptFile "path\to\your\script.ps1"
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Description` | String | Yes | A descriptive name for the certificate (e.g., "My Development Cert") |
| `ScriptFile` | String | Yes | Path to the file or directory you want to sign |

## Examples

### Sign a PowerShell script
```powershell
.\GeneSelfSign.ps1 -Description "MyApp Development Certificate" -ScriptFile "C:\Scripts\MyScript.ps1"
```

### Sign an executable
```powershell
.\GeneSelfSign.ps1 -Description "MyApp Production Certificate" -ScriptFile "C:\Apps\MyApp.exe"
```

## What the Script Does

1. **Validates Input**: Checks if the specified file path is valid
2. **Creates Certificate**: Generates a new self-signed code signing certificate with:
   - RSA algorithm with 4096-bit key length
   - Code signing purpose
   - Valid until January 1, 2099
   - Stored in the current user's certificate store
3. **Moves to Root Store**: Transfers the certificate to the trusted root certificate store
4. **Applies Signature**: Signs the specified file or directory with the generated certificate

## Certificate Details

- **Subject**: `CN={Description}, OU=Self-signed RootCA`
- **Key Algorithm**: RSA
- **Key Length**: 4096 bits
- **Certificate Type**: Code Signing
- **Store Location**: `Cert:\CurrentUser\My\` (then moved to `Cert:\CurrentUser\Root`)
- **Expiration**: January 1, 2099

## Security Considerations

⚠️ **Important**: This script creates self-signed certificates, which are suitable for development and testing but should not be used in production environments. For production use, consider using certificates from trusted Certificate Authorities (CAs).

## Troubleshooting

### Common Issues

1. **Execution Policy Error**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Permission Denied**
   - Run PowerShell as Administrator
   - Ensure you have access to the certificate store

3. **File Not Found**
   - Verify the file path is correct
   - Use absolute paths if necessary

### Verification

To verify the signature was applied successfully:
```powershell
Get-AuthenticodeSignature "path\to\your\file"
```
