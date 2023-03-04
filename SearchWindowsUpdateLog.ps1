Function Search-Log
{
$F = "c:\users\mstrauss\desktop\WindowsUpdate.log"
Select-String -Path $F -Pattern 'Failed'

}
