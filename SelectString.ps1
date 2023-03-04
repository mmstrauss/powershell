#select-string -Path "C:\users\MStrauss\Desktop\CBS.log" -Pattern 'HRESULT = 0x800f0831'

#select-string -Path "C:\users\MStrauss\Desktop\CBS.log" -Pattern 'HRESULT = servicing'

#KB5003503
#select-string -Path "C:\users\MStrauss\Desktop\CBS.log" -Pattern 'HRESULT = _KB5003503'

select-string -Path "C:\users\MStrauss\Desktop\DISM.log" -Pattern 'HRESULT = 25/10/2021'


