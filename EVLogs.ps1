﻿Get-Content EV* | Select-String "BadCard" | ConvertFrom-Csv -Header "Date","Time","Message","SiteId","A","B","OPTNum","C" | Group-Object Date, OPTNum | Select Name, Count | ConvertTo-Csv