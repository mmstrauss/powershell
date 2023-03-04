$folder="C:\Users\MStrauss\HTEC Limited\PSP PCI - EVIDENCE\2021 PSP Assessment\ValidationMatrix\OSEvidence";             # Directory to place the new folders in.
$txtFile="c:\temp\list.txt"; # File with list of new folder-names
$pattern="\d+.+";              # Pattern that lines must match      


get-content $txtFile | %{

    if($_ -match $pattern)
    {
        mkdir "$folder\$_";
    }
}