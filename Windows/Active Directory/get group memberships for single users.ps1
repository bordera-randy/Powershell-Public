
(Get-ADuser -Identity Pawel.Janowicz -Properties memberof).memberof | Get-ADGroup | Select-Object name | Sort-Object name