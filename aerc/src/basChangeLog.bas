Option Compare Database
Option Explicit

' Problems:
' ReadDocDatabase debug output when custom test folder given
' Exists function debug output
' Test for expected references when class first created
' Import of class source code into a new database creates a module
' Public Function aeReadDocDatabase - does it need a Get property call to make the function Private?
'


' 20121128 - v016 - SourceFolder property updated to allow passing the path into the class
    ' Cleanup debug messages code, include GetReferences from aeladdin (tm)
' 20121127 - v015 - delete mac1 from accdb and manually delete the S_mac1.def file as the data export does not delete files
    ' version number continues from zip files stored in OLD folder
    ' basChangeLog added, export with OASIS and commit new changes to github