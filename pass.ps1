$words = Get-Content .\words.txt
$wordCount = 3 # number of words to form a password phrase
$randomNumberRange = 10000..99999 # range of numbers to append to phrase

(($words | Get-Random -Count $wordCount | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) }) -join '') + [string]($randomNumberRange | Get-Random)
