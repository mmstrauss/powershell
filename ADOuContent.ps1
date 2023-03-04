$OUpath = 'ou=Managers,dc=enterprise,dc=com'
$ExportPath = 'c:\data\computers_in_ou.csv'
Get-ADComputer -Filter * -SearchBase $OUpath | Select-object
DistinguishedName,DNSHostName,Name | Export-Csv -NoType $ExportPath