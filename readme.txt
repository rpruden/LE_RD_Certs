This script is designed to be used with Certify The Web which is a GUI client for Lets Encrypt.

To use this script, simply save it to a predefined directory (C:\Scripts\CertifyTheWeb\LE_Renew.ps1).

From within Certify The Web;
1. Select the cert you wish to use this script on
2. Tick the box for, "Show Advanced Options"
3. Click the section for "Deployment"
4. Set Deployment mode to "Certificate Store Only"
5. Click the section for "Scripting"
6. Add the path to the script in the "Post-request PS Script" box
7. Save your changes

Whenever your CTR client performs an auto renewal, it will execute this script and re-apply the certificates as needed.

This has been tested in server 2016 and server 2019.
