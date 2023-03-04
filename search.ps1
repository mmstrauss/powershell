# Function to search log files for specified string of words
# Variable $SearchPath specifies the log file location, searches the string specified

Function Search-log
{
    $SearchPath = "c:\logs\dns.csv"
    Select-String -Path $SearchPath -Pattern "192.168.200.245"
}

# calls function and save search results to 
search-log >c:\temp\searchlogdns.txt

#calls the file that you just wrote to
notepad C:\temp\searchlogdns.txt