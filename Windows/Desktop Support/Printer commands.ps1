# list the printers installed on a computer is to use the WMI Win32_Printer class:
Get-CimInstance -Class Win32_Printer



#You can also list the printers by using the WScript.Network COM object that is typically used in WSH scripts:

(New-Object -ComObject WScript.Network).EnumPrinterConnections()

#To add a new network printer, use WScript.Network:
(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\Printserver01\Xerox5")


#To use WMI to set the default printer, find the printer in the Win32_Printer collection and then invoke the SetDefaultPrinter method:
(Get-CimInstance -Class Win32_Printer -Filter "Name='HP LaserJet 5Si'").SetDefaultPrinter()

#WScript.Network is a little simpler to use, because it has a SetDefaultPrinter method that takes only the printer name as an argument:
(New-Object -ComObject WScript.Network).SetDefaultPrinter('HP LaserJet 5Si')


#To remove a printer connection, use the WScript.Network RemovePrinterConnection method:
(New-Object -ComObject WScript.Network).RemovePrinterConnection("\\Printserver01\Xerox5")

