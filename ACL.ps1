$acl = Get-Acl -Path "C:\Users\htec\Desktop\ASDA First Fix Guide V2.pdf"
$acl.SetAccessRuleProtection($true, $false) # Disable inheritance 
# SYSTEM Full Control Allow
$acl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("NT AUTHORITY\SYSTEM", "FullControl", "Allow"))
# Admins Full Control Allow
$acl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators", "FullControl", "Allow"))
# htec Write Deny 
$acl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("htec", "Write", "Deny"))
# htec Delete Deny 
$acl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("htec", "Delete", "Deny"))
# htec Read Allow
$acl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("htec", "Read", "Allow"))
Set-Acl -Path "C:\Users\htec\Desktop\ASDA First Fix Guide V2.pdf" -AclObject $acl
# Set the desktop folder to Deny deletion of subdirectories and files
# this is equal parts confusing and misleading as it still ALLOWS it and only denies on objects where Delete is explicitly denied as above '("htec", "Delete", "Deny")'
# i.e. any other file/folder on the desktop can be still be deleted even though DeleteSubdirectoriesAndFiles is denied...
$desktopAcl = Get-Acl -Path "C:\Users\htec\Desktop"
$desktopAcl.SetAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new("htec", "DeleteSubdirectoriesAndFiles", "Deny"))
Set-Acl -Path "C:\Users\htec\Desktop" -AclObject $desktopAcl