Get-HotFix |

Where {

    $_.InstalledOn -gt "11/02/2021" } |

    sort InstalledOn