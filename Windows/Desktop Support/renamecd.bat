FOR /F %%V IN (
	'mountvol.exe D: /L'
) DO ( 
	mountvol.exe D: /D
	mountvol.exe E: %%V
)