## Default Params from Certify The Web client
param($result)
 
Import-Module RemoteDesktopServices
 
if ($result.IsSuccess)
{
##New Commands
# Install a Let's Encrypt certificate to Remote Desktop Services
# Hacked together by Anthony Eden (https://mediarealm.com.au/)
# Modified by Anthony P. (https://github.com/rpruden/)
 
#Credit: https://ryanmangansitblog.com/2014/06/17/deploying-rds-2012-wild-card-certificate-using-powershell/
#Credit: https://github.com/Lone-Coder/letsencrypt-win-simple/issues/400
 
$CertificateImport = $result.ManagedItem.CertificatePath
$RDCB = [System.Net.Dns]::GetHostByName($env:computerName).HostName
#if ( ((get-date) - (ls $CertificateImport).LastWriteTime).minutes -gt 10){ exit }
 
# This is where a temporary certificate will be stored (we delete it at the end)
$tempPfxPath = 'C:\ProgramData\Certify\certes\assets\pfx\temp-pfx.pfx'
 
# Import the RemoteDesktop module
Import-Module RemoteDesktop
 
# Create the temporary certificate
$newCertPfx = Import-PfxCertificate -FilePath $CertificateImport -CertStoreLocation Cert:\LocalMachine\My -Exportable
$tempPasswordPfx = ConvertTo-SecureString -String "TemporaryPassword" -Force -AsPlainText
Export-PfxCertificate -cert $newCertPfx -FilePath $tempPfxPath -Force -NoProperties -Password $tempPasswordPfx
Remove-Item -Path $newCertPfx.PSPath
 
 
# Configure RDPublishing Certificate for RDS
set-RDCertificate -Role RDPublishing `
   -ImportPath $tempPfxPath `
   -Password $tempPasswordPfx `
   -ConnectionBroker $RDCB -Force `
 
# Configure RDWebAccess Certificate for RDS
set-RDCertificate -Role RDWebAccess `
   -ImportPath $tempPfxPath `
   -Password $tempPasswordPfx `
   -ConnectionBroker $RDCB -Force `
    
# Configure RDRedirector Certificate for RDS
set-RDCertificate -Role RDRedirector `
   -ImportPath $tempPfxPath `
   -Password $tempPasswordPfx `
   -ConnectionBroker $RDCB -force `
 
# Configure RDGateway Certificate for RDS
set-RDCertificate -Role RDGateway `
   -ImportPath $tempPfxPath `
   -Password $tempPasswordPfx `
   -ConnectionBroker $RDCB -force `
    
# Cleanup the temporary PFX file
Remove-Item -Path $tempPfxPath
}
