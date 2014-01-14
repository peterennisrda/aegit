Option Compare Database
Option Explicit

Private Const TEST_FILE_PATH As String = "C:\TEMP"
Private Const FOR_READING = 1
' Remove this after integration with aegitClass
Public Const THE_SOURCE_FOLDER = "C:\ae\aegit\aerc\src\"

'Private Enum DisplayControlType
'    CheckBox = 106
'    TextBox = 109
'    ListBox = 110
'    ComboBox = 111
'End Enum

Public Sub TestCreateDbScript()
    'CreateDbScript "C:\Temp\Schema.txt"
    Debug.Print "THE_SOURCE_FOLDER=" & THE_SOURCE_FOLDER
    CreateDbScript THE_SOURCE_FOLDER & "Schema.txt"
End Sub

Public Sub CreateDbScript(strScriptFile As String)
' Remou - Ref: http://stackoverflow.com/questions/698839/how-to-extract-the-schema-of-an-access-mdb-database/9910716#9910716

    Dim db As DAO.Database
    Dim tdf As DAO.TableDef
    Dim fld As DAO.Field
    Dim ndx As DAO.Index
    Dim strSQL As String
    Dim strFlds As String
    Dim strCn As String
    Dim strLinkedTablePath As String
    Dim fs As Object
    Dim f As Object

    Set db = CurrentDb
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.CreateTextFile(strScriptFile)

    strSQL = "Public Sub CreateTheDb()" & vbCrLf
    f.WriteLine strSQL
    strSQL = "Dim strSQL As String"
    f.WriteLine strSQL
    strSQL = "On Error GoTo ErrorTrap"
    f.WriteLine strSQL

    For Each tdf In db.TableDefs
        If Not (Left(tdf.Name, 4) = "MSys" _
                Or Left(tdf.Name, 4) = "~TMP" _
                Or Left(tdf.Name, 3) = "zzz") Then

MsgBox "FIXME"
Stop
'strLinkedTablePath = GetLinkedTableCurrentPath(tdf.Name)
            If strLinkedTablePath <> "" Then
                f.WriteLine vbCrLf & "'OriginalLink=>" & strLinkedTablePath
            Else
                f.WriteLine vbCrLf & "'Local Table"
            End If

            strSQL = "strSQL=""CREATE TABLE [" & tdf.Name & "] ("
            strFlds = ""

            For Each fld In tdf.Fields

                strFlds = strFlds & ",[" & fld.Name & "] "

                Select Case fld.Type
                    Case dbText
                        'No look-up fields
                        strFlds = strFlds & "Text (" & fld.Size & ")"
                    Case dbLong
                        If (fld.Attributes And dbAutoIncrField) = 0& Then
                            strFlds = strFlds & "Long"
                        Else
                            strFlds = strFlds & "Counter"
                        End If
                    Case dbBoolean
                        strFlds = strFlds & "YesNo"
                    Case dbByte
                        strFlds = strFlds & "Byte"
                    Case dbInteger
                        strFlds = strFlds & "Integer"
                    Case dbCurrency
                        strFlds = strFlds & "Currency"
                    Case dbSingle
                        strFlds = strFlds & "Single"
                    Case dbDouble
                        strFlds = strFlds & "Double"
                    Case dbDate
                        strFlds = strFlds & "DateTime"
                    Case dbBinary
                        strFlds = strFlds & "Binary"
                    Case dbLongBinary
                        strFlds = strFlds & "OLE Object"
                    Case dbMemo
                        If (fld.Attributes And dbHyperlinkField) = 0& Then
                            strFlds = strFlds & "Memo"
                        Else
                            strFlds = strFlds & "Hyperlink"
                        End If
                    Case dbGUID
                        strFlds = strFlds & "GUID"
                End Select

            Next

            strSQL = strSQL & Mid(strFlds, 2) & " )""" & vbCrLf & "Currentdb.Execute strSQL"
            f.WriteLine vbCrLf & strSQL

            'Indexes
            For Each ndx In tdf.Indexes

                If ndx.Unique Then
                    strSQL = "strSQL=""CREATE UNIQUE INDEX "
                Else
                    strSQL = "strSQL=""CREATE INDEX "
                End If

                strSQL = strSQL & "[" & ndx.Name & "] ON [" & tdf.Name & "] ("
                strFlds = ""

                For Each fld In tdf.Fields
                    strFlds = ",[" & fld.Name & "]"
                Next

                strSQL = strSQL & Mid(strFlds, 2) & ") "
                strCn = ""

                If ndx.Primary Then
                    strCn = " PRIMARY"
                End If

                If ndx.Required Then
                    strCn = strCn & " DISALLOW NULL"
                End If

                If ndx.IgnoreNulls Then
                    strCn = strCn & " IGNORE NULL"
                End If

                If Trim(strCn) <> vbNullString Then
                    strSQL = strSQL & " WITH" & strCn & " "
                End If

                f.WriteLine vbCrLf & strSQL & """" & vbCrLf & "Currentdb.Execute strSQL"
            Next
        End If
    Next

    'strSQL = vbCrLf & "Debug.Print " & """" & "Done" & """"
    'f.WriteLine strSQL
    f.WriteLine
    f.WriteLine "'Access 2010 - Compact And Repair"
    strSQL = "SendKeys " & """" & "%F{END}{ENTER}%F{TAB}{TAB}{ENTER}" & """" & ", False"
    f.WriteLine strSQL
    strSQL = "Exit Sub"
    f.WriteLine strSQL
    strSQL = "ErrorTrap:"
    f.WriteLine strSQL
    'MsgBox "Erl=" & Erl & vbCrLf & "Err.Number=" & Err.Number & vbCrLf & "Err.Description=" & Err.Description
    strSQL = "MsgBox " & """" & "Erl=" & """" & " & vbCrLf & " & _
                """" & "Err.Number=" & """" & " & Err.Number & vbCrLf & " & _
                """" & "Err.Description=" & """" & " & Err.Description"
    f.WriteLine strSQL & vbCrLf
    strSQL = "End Sub"
    f.WriteLine strSQL

    f.Close
    Debug.Print "Done"

End Sub

Public Sub ObjectCounts()
 
    Dim qry As DAO.QueryDef
    Dim cnt As DAO.Container
 
    'Delete all TEMP queries ...
    For Each qry In CurrentDb.QueryDefs
        If Left(qry.Name, 1) = "~" Then
            CurrentDb.QueryDefs.Delete qry.Name
            CurrentDb.QueryDefs.Refresh
        End If
    Next qry
 
    'Print the values to the immediate window
    With CurrentDb
 
        Debug.Print "--- From the DAO.Database ---"
        Debug.Print "-----------------------------"
        Debug.Print "Tables (Inc. System tbls): " & .TableDefs.Count
        Debug.Print "Querys: " & .QueryDefs.Count & vbCrLf
 
        For Each cnt In .Containers
            Debug.Print cnt.Name & ":" & cnt.Documents.Count
        Next cnt
 
    End With
 
    'Use the "Project" collections to get the counts of objects
    With CurrentProject
        Debug.Print vbCrLf & "--- From the Access 'Project' ---"
        Debug.Print "---------------------------------"
        Debug.Print "Forms: " & .AllForms.Count
        Debug.Print "Reports: " & .AllReports.Count
        Debug.Print "DataAccessPages: " & .AllDataAccessPages.Count
        Debug.Print "Modules: " & .AllModules.Count
        Debug.Print "Macros (aka Scripts): " & .AllMacros.Count
    End With
 
End Sub

Private Function GetType(Value As Long) As String
' Ref: http://bytes.com/topic/access/answers/557780-getting-string-name-enum

    Select Case Value
        Case acCheckBox
            GetType = "CheckBox"
        Case acTextBox
            GetType = "TextBox"
        Case acListBox
            GetType = "ListBox"
        Case acComboBox
            GetType = "ComboBox"
        Case Else
    End Select

End Function

Public Function FieldLookupControlTypeList() As Boolean
' Ref: http://support.microsoft.com/kb/304274
' Ref: http://msdn.microsoft.com/en-us/library/office/bb225848(v=office.12).aspx
' 106 - acCheckBox, 109 - acTextBox, 110 - acListBox, 111 - acComboBox

    ' Use a call stack and global error handler
    'If gcfHandleErrors Then On Error GoTo PROC_ERR
    'PushCallStack "FieldLookupControlTypeList"

    On Error GoTo PROC_ERR

    Dim dbs As DAO.Database
    Dim tdf As DAO.TableDefs
    Dim tbl As DAO.TableDef
    Dim fld As Field
    Dim lng As Long
    Dim strChkTbl As String
    Dim strChkFld As String

    ' Counters for DisplayControl types
    Static intChk As Integer
    Static intTxt As Integer
    Static intLst As Integer
    Static intCbo As Integer
    Static intAllFieldsCount As Integer
    Static intOther As Integer

    Set dbs = CurrentDb()
    Set tdf = dbs.TableDefs

    intChk = 0
    intTxt = 0
    intLst = 0
    intCbo = 0
    intAllFieldsCount = 0
    intOther = 0

    On Error Resume Next
    For Each tbl In tdf
        If Left(tbl.Name, 4) <> "MSys" Then
            Debug.Print tbl.Name
            For Each fld In tbl.Fields
                intAllFieldsCount = intAllFieldsCount + 1
                lng = fld.Properties("DisplayControl").Value
                Debug.Print , fld.Name, lng, GetType(lng)
                Select Case lng
                    Case acCheckBox
                        intChk = intChk + 1
                        'Debug.Print intChk, ">Here"
                        strChkTbl = tbl.Name
                        strChkFld = fld.Name
                    Case acTextBox
                        intTxt = intTxt + 1
                        'Debug.Print intTxt, ">Here"
                    Case acListBox
                        intLst = intLst + 1
                        'Debug.Print intLst, ">Here"
                    Case acComboBox
                        intCbo = intCbo + 1
                        'Debug.Print intCbo, ">Here"
                    Case Else
                        intOther = intOther + 1
                        'MsgBox "lng=" & lng
                End Select
            Next fld
        End If
    Next tbl
    Debug.Print "Count of Check box = " & intChk
    Debug.Print "Count of Text box  = " & intTxt
    Debug.Print "Count of List box  = " & intLst
    Debug.Print "Count of Combo box = " & intCbo
    Debug.Print "Count of Other     = " & intOther
    Debug.Print "Count of Display Controls = " & intChk + intTxt + intLst + intCbo
    Debug.Print "Count of All Fields = " & intAllFieldsCount - intOther
    Debug.Print "Table with check box is " & strChkTbl
    Debug.Print "Field with check box is " & strChkFld

    If intAllFieldsCount - intOther = intChk + intTxt + intLst + intCbo Then
        FieldLookupControlTypeList = True
    Else
        FieldLookupControlTypeList = False
    End If

PROC_EXIT:
    On Error Resume Next
    Set tdf = Nothing
    Set dbs = Nothing
    'PopCallStack
    Exit Function

PROC_ERR:
    MsgBox "erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure FieldLookupControlTypeList of Class aegitClass", vbCritical, "Error"
    'GlobalErrHandler
    Resume PROC_EXIT

End Function
 
' Ref: http://www.utteraccess.com/forum/lofiversion/index.php/t1995627.html
'-------------------------------------------------------------------------------------------------
' Procedure : ExecSQL
' DateTime  : 30/03/2009 10:19
' Author    : Dial222
' Purpose   : Execute SQL Select statements in the Immediate window
' Context   : Module basSQL2IMM
' Notes     : No error trapping whatsover - this is a 1.0 technology!
'             Max out at 194 data rows since immediate only displays 100!
'
' Usage     : in the immediate pane: ?execsql("select * from zstblprofile","|")
'
' Revision History
' Version   Date        Who             What
' 01        30/03/2009  Dial222         Function 'ExecSQL' Created
' 02        30/03/2009  Dial222         Added code for left/right align of text/numeric data
'                                       Added MaxRowLen and vbCrLF parsing functionality
'                                       Uprated cMaxRows to 194
'-------------------------------------------------------------------------------------------------
'

Public Function ExecSQL(strSQL As String, Optional strColumDelim As String = "|") As Boolean

    Dim rs              As DAO.Recordset
    Dim aintLen()       As Integer
    Dim i               As Integer
    Dim str             As String
    Dim lngRowCOunt     As Long

    Const cMaxRows      As Integer = 194
    Const cMaxRowLen    As Integer = 1023  ' Max width of immediate pane in characters, truncate after this.

    Set rs = CurrentDb.OpenRecordset(strSQL, dbOpenDynaset, dbSeeChanges)

    With rs
        .MoveLast
        .MoveFirst

        lngRowCOunt = .RecordCount
        If lngRowCOunt > 0 Then
            If lngRowCOunt > cMaxRows Then
                Debug.Print "Too many rows to return, will only print first " & cMaxRows & " rows."
            End If

            ReDim Preserve aintLen(.Fields.Count)

            For i = 0 To .Fields.Count - 1
                ' Initialise field len to field name len
                aintLen(i) = Len(.Fields(i).Name) + 3
            Next i

            ' On this pass just get length of field data for formatting
            Do Until .EOF
                If .AbsolutePosition = cMaxRows Then
                    ' Stop at the magic number
                    Exit Do
                Else
                    For i = 0 To rs.Fields.Count - 1
                        ' Test and update field len
                        If Len(CStr(Nz(.Fields(i).Value, ""))) > aintLen(i) Then
                            aintLen(i) = Len(CStr(.Fields(i).Value)) + 3
                        End If
                    Next i
                End If
                .MoveNext
            Loop

            ' Print Column Headers
            str = "Row " & strColumDelim & " "
            For i = 0 To rs.Fields.Count - 1
                ' Initialise field len to field name len
                str = str & Left(.Fields(i).Name & Space(aintLen(i)), aintLen(i)) & " " & strColumDelim & " "
            Next i

            ' Print the header row
            Debug.Print Left(str, cMaxRowLen)
            str = Space(Len(str))
            str = Replace(str, " ", "-")

            ' print underscores
            Debug.Print Left(str, cMaxRowLen)
            str = ""

            ' Start over for the data
            .MoveFirst

            Do Until .EOF
                If .AbsolutePosition = cMaxRows Then
                    Exit Do
                Else
                    str = Left(.AbsolutePosition + 1 & Space(3), 3) & " " & strColumDelim & " "
                    For i = 0 To .Fields.Count - 1
                        Select Case .Fields(i).Type
                            Case Is = 3, 4, 5, 6, 7, 8, 16, 19, 20, 21, 22, 23 ' The numeric DataTypeEnums
                                str = str & Right(Space(aintLen(i)) & .Fields(i).Value, aintLen(i)) & " " & strColumDelim & " "
                            Case Else
                                ' Is it number stored as text
                                If IsNumeric(.Fields(i).Value) Then
                                    ' Right align
                                    str = str & Right(Space(aintLen(i)) & .Fields(i).Value, aintLen(i)) & " " & strColumDelim & " "
                                Else
                                    ' Left align
                                    str = str & Left(.Fields(i).Value & Space(aintLen(i)), aintLen(i)) & " " & strColumDelim & " "
                                End If
                        End Select
                    Next i
                End If

                ' Parse out vbCrLf and dump data row to immediate
                Debug.Print Left(Replace(Replace(str, Chr(13), " "), Chr(10), " "), cMaxRowLen)
                .MoveNext
                str = ""
            Loop

            ExecSQL = True
        Else
            Debug.Print "No rows returned"
        End If
    End With

    Set rs = Nothing

End Function

Public Function SpFolder(SpName)

    Dim objShell As Object
    Dim objFolder As Object
    Dim objFolderItem As Object

    Set objShell = CreateObject("Shell.Application")
    Set objFolder = objShell.Namespace(SpName)

    Set objFolderItem = objFolder.Self

    SpFolder = objFolderItem.Path

End Function
   
Public Sub ExportAllModulesToFile()
' Ref: http://wiki.lessthandot.com/index.php/Code_and_Code_Windows
' Ref: http://stackoverflow.com/questions/2794480/exporting-code-from-microsoft-access
' The reference for the FileSystemObject Object is Windows Script Host Object Model
' but it not necessary to add the reference for this procedure.

    Const Desktop = &H10&
    Const MyDocuments = &H5&

    Dim fso As Object
    Dim fil As Object
    Dim strMod As String
    Dim mdl As Object
    Dim i As Integer
    Dim strTxtFile As String

    Set fso = CreateObject("Scripting.FileSystemObject")

    ' Set up the file
    Debug.Print "CurrentProject.Name = " & CurrentProject.Name
    strTxtFile = SpFolder(Desktop) & "\" & Replace(CurrentProject.Name, ".", "_") & ".txt"
    Debug.Print "strTxtFile = " & strTxtFile
    Set fil = fso.CreateTextFile(SpFolder(Desktop) & "\" _
            & Replace(CurrentProject.Name, ".", " ") & ".txt")

    ' For each component in the project ...
    For Each mdl In VBE.ActiveVBProject.VBComponents
        ' using the count of lines ...
        If Left(mdl.Name, 3) <> "zzz" Then
            Debug.Print mdl.Name
            i = VBE.ActiveVBProject.VBComponents(mdl.Name).CodeModule.CountOfLines
            ' put the code in a string ...
            If i > 0 Then
                strMod = VBE.ActiveVBProject.VBComponents(mdl.Name).CodeModule.Lines(1, i)
            End If
            ' and then write it to a file, first marking the start with
            ' some equal signs and the component name.
            fil.WriteLine String(15, "=") & vbCrLf & mdl.Name _
                & vbCrLf & String(15, "=") & vbCrLf & strMod
        End If
    Next
       
    'Close eveything
    fil.Close
    Set fso = Nothing

End Sub

Public Function PropertyExists(obj As Object, strPropertyName As String) As Boolean
' Ref: http://www.utteraccess.com/forum/Description-property-Mic-t552348.html
' e.g. ? PropertyExists(CurrentDB. ("The Name Of Your Table"), "Description")
    Dim var As Variant

    On Error Resume Next
    Set var = obj.Properties(strPropertyName)
    If Err.Number > 0 Then
        PropertyExists = False
    Else
        PropertyExists = True
    End If

End Function

Public Sub GetPropertyDescription()
' Ref: http://www.dbforums.com/microsoft-access/1620765-read-ms-access-table-properties-using-vba.html

    Dim dbs As DAO.Database
    Dim obj As Object
    Dim prp As Property

    Set dbs = Application.CurrentDb
    Set obj = dbs.Containers("modules").Documents("aegitClass")

    On Error Resume Next
    For Each prp In obj.Properties
        Debug.Print prp.Name, prp.Value
    Next prp

    Set obj = Nothing
    Set dbs = Nothing

End Sub

Public Sub TestListAllProperties()
    'ListAllProperties ("modules")
    ListAllProperties ("tables")
End Sub

Public Sub ListGUID()
' Ref: http://stackoverflow.com/questions/8237914/how-to-get-the-guid-of-a-table-in-microsoft-access

    Dim i As Integer
    Dim arrGUID8() As Byte
    Dim strGuid As String

    arrGUID8 = CurrentDb.TableDefs("tblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger").Properties("GUID").Value
    For i = 1 To 8
        strGuid = strGuid & Hex(arrGUID8(i)) & "-"
    Next
    Debug.Print Left(strGuid, 23)

End Sub

Public Function fListGUID(strTableName As String) As String
' Ref: http://stackoverflow.com/questions/8237914/how-to-get-the-guid-of-a-table-in-microsoft-access
' e.g. ?fListGUID("tblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger")

    Dim i As Integer
    Dim arrGUID8() As Byte
    Dim strGuid As String

    arrGUID8 = CurrentDb.TableDefs(strTableName).Properties("GUID").Value
    For i = 1 To 8
        strGuid = strGuid & Hex(arrGUID8(i)) & "-"
    Next
    'Debug.Print Left(strGUID, 23)
    fListGUID = Left(strGuid, 23)

End Function

Public Sub ListAllProperties(strContainer As String)
' Ref: http://www.dbforums.com/microsoft-access/1620765-read-ms-access-table-properties-using-vba.html
' Ref: http://ms-access.veryhelper.com/q_ms-access-database_153855.html
' Ref: http://msdn.microsoft.com/en-us/library/office/aa139941(v=office.10).aspx
    
    Dim dbs As DAO.Database
    Dim obj As Object
    Dim prp As Property
    Dim doc As Document

    Set dbs = Application.CurrentDb
    Set obj = dbs.Containers(strContainer)

    'Debug.Print "Modules", obj.Documents.Count
    'Debug.Print "Modules", obj.Documents(1).Name
    'Debug.Print "Modules", obj.Documents(2).Name

    ' Ref: http://stackoverflow.com/questions/16642362/how-to-get-the-following-code-to-continue-on-error
    For Each doc In obj.Documents
        If Left(doc.Name, 4) <> "MSys" And Left(doc.Name, 3) <> "zzz" Then
            Debug.Print ">>>" & doc.Name
            For Each prp In doc.Properties
                On Error Resume Next
                    If prp.Name = "GUID" And strContainer = "tables" Then
                        Debug.Print prp.Name, fListGUID(doc.Name)
                    ElseIf prp.Name = "DOL" Then
                        Debug.Print prp.Name, "Track name AutoCorrect info is ON!"
                    ElseIf prp.Name = "NameMap" Then
                        Debug.Print prp.Name, "Track name AutoCorrect info is ON!"
                    Else
                        Debug.Print prp.Name, prp.Value
                    End If
                On Error GoTo 0
            Next
        End If
    Next

    Set obj = Nothing
    Set dbs = Nothing

End Sub

Public Sub TestPropertiesOutput()
' Ref: http://www.everythingaccess.com/tutorials.asp?ID=Accessing-detailed-file-information-provided-by-the-Operating-System
' Ref: http://www.techrepublic.com/article/a-simple-solution-for-tracking-changes-to-access-data/
' Ref: http://social.msdn.microsoft.com/Forums/office/en-US/480c17b3-e3d1-4f98-b1d6-fa16b23c6a0d/please-help-to-edit-the-table-query-form-and-modules-modified-date
'
' Ref: http://perfectparadigm.com/tip001.html
'SELECT MSysObjects.DateCreate, MSysObjects.DateUpdate,
'MSysObjects.Name , MSysObjects.Type
'FROM MSysObjects;

    Debug.Print ">>>frm_Dummy"
    Debug.Print "DateCreated", DBEngine(0)(0).Containers("Forms")("frm_Dummy").Properties("DateCreated").Value
    Debug.Print "LastUpdated", DBEngine(0)(0).Containers("Forms")("frm_Dummy").Properties("LastUpdated").Value

' *** Ref: http://support.microsoft.com/default.aspx?scid=kb%3Ben-us%3B299554 ***
'When the user initially creates a new Microsoft Access specific-object, such as a form), the database engine still
'enters the current date and time into the DateCreate and DateUpdate columns in the MSysObjects table. However, when
'the user modifies and saves the object, Microsoft Access does not notify the database engine; therefore, the
'DateUpdate column always stays the same.

' Ref: http://questiontrack.com/how-can-i-display-a-last-modified-time-on-ms-access-form-995507.html

    Dim obj As AccessObject
    Dim dbs As Object

    Set dbs = Application.CurrentData
    Set obj = dbs.AllTables("tblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger")
    Debug.Print ">>>" & obj.Name
    Debug.Print "DateCreated: " & obj.DateCreated
    Debug.Print "DateModified: " & obj.DateModified

End Sub

Public Sub SaveTableMacros()

    ' Export Table Data to XML
    ' Ref: http://technet.microsoft.com/en-us/library/ee692914.aspx
    Application.ExportXML acExportTable, "Items", "C:\Temp\ItemsData.xml"

    ' Save table macros as XML
    ' Ref: http://www.access-programmers.co.uk/forums/showthread.php?t=99179
    Application.SaveAsText acTableDataMacro, "Items", "C:\Temp\Items.xml"
    Debug.Print , "Items table macros saved to C:\Temp\Items.xml"

    ' Beautify XML in VBA with MSXML6 only
    ' Ref: http://social.msdn.microsoft.com/Forums/en-US/409601d4-ca95-448a-aafc-aa0ee1ad67cd/beautify-xml-in-vba-with-msxml6-only?forum=xmlandnetfx
    Dim objXMLStyleSheet As Object
    Dim strXMLStyleSheet As String
    Dim objXMLDOMDoc As Object

    strXMLStyleSheet = "<xsl:stylesheet" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "  xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "  version=""1.0"">" & vbCrLf & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "<xsl:output method=""xml"" indent=""yes""/>" & vbCrLf & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "<xsl:template match=""@* | node()"">" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "  <xsl:copy>" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "    <xsl:apply-templates select=""@* | node()""/>" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "  </xsl:copy>" & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "</xsl:template>" & vbCrLf & vbCrLf
    strXMLStyleSheet = strXMLStyleSheet & "</xsl:stylesheet>"

    Dim objXMLResDoc As Object

    Set objXMLStyleSheet = CreateObject("Msxml2.DOMDocument.6.0")
    With objXMLStyleSheet
        'Turn off Async I/O
        .async = False
        .validateOnParse = False
        .resolveExternals = False
    End With

    objXMLStyleSheet.LoadXML (strXMLStyleSheet)
    If objXMLStyleSheet.parseError.errorCode <> 0 Then
        Debug.Print "Some Error..."
        Exit Sub
    End If

    Set objXMLDOMDoc = CreateObject("Msxml2.DOMDocument.6.0")
    With objXMLDOMDoc
        'Turn off Async I/O
        .async = False
        .validateOnParse = False
        .resolveExternals = False
    End With

    ' Ref: http://msdn.microsoft.com/en-us/library/ms762722(v=vs.85).aspx
    ' Ref: http://msdn.microsoft.com/en-us/library/ms754585(v=vs.85).aspx
    ' Ref: http://msdn.microsoft.com/en-us/library/aa468547.aspx
    objXMLDOMDoc.Load ("C:\Temp\Items.xml")

    Dim strXMLResDoc
    Set strXMLResDoc = CreateObject("Msxml2.DOMDocument.6.0")

    objXMLDOMDoc.transformNodeToObject objXMLStyleSheet, strXMLResDoc
    strXMLResDoc = strXMLResDoc.XML
    strXMLResDoc = Replace(strXMLResDoc, vbTab, Chr(32) & Chr(32), , , vbBinaryCompare)
    Debug.Print "Pretty XML Sample Output"
    Debug.Print strXMLResDoc

    Set objXMLDOMDoc = Nothing
    Set objXMLStyleSheet = Nothing

End Sub

Sub ApplicationInformation()
' Ref: http://msdn.microsoft.com/en-us/library/office/aa223101(v=office.11).aspx

    Debug.Print Application.CurrentProject.FullName
    Debug.Print Application.CurrentProject.ProjectType

End Sub

Public Sub SetRefToLibrary()
' http://www.exceltoolset.com/setting-a-reference-to-the-vba-extensibility-library-by-code/
' Adjusted for Microsoft Access
' Create a reference to the VBA Extensibility library
    On Error Resume Next        ' in case the reference already exits
    Access.Application.VBE.ActiveVBProject.References _
                  .AddFromGuid "{0002E157-0000-0000-C000-000000000046}", 5, 0
End Sub

Public Function TotalLinesInProject(Optional VBProj As Object = Nothing) As Long
'Public Function TotalLinesInProject(Optional VBProj As VBIDE.VBProject = Nothing) As Long
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Reference to Microsoft Visual Basic For Applications Extensibility 5.3
' was required in old code.
' Ref: http://www.cpearson.com/excel/vbe.aspx
' Adjusted for Microsoft Access and Late Binding. No reference needed.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' This returns the total number of lines in all components of the VBProject
' referenced by VBProj. If VBProj is missing, the VBProject of the
' Access.Application is used. Returns -1 if the VBProject is locked.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Dim VBP As Object               'VBIDE.VBProject
    Dim VBComp As Object            'VBIDE.VBComponent
    Dim LineCount As Long
    
    ' Ref: http://www.access-programmers.co.uk/forums/showthread.php?t=245480
    Const vbext_pp_locked = 1

    If VBProj Is Nothing Then
        Set VBP = Access.Application.VBE.ActiveVBProject
    Else
        Set VBP = VBProj
    End If

    If VBP.Protection = vbext_pp_locked Then
        TotalLinesInProject = -1
        Exit Function
    End If

    For Each VBComp In VBP.VBComponents
        LineCount = LineCount + VBComp.CodeModule.CountOfLines
    Next VBComp
    
    TotalLinesInProject = LineCount

End Function

Public Sub ListFilesRecursively()
'Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx
'====================================================================
' Purpose:  List Files Recursively
' Author:   Peter Ennis
' Date:     February 10, 2011
' Comment:  Fix to work in VBA. Based on MSDN sample for WScript
' Requires: Reference to Microsoft Scripting Runtime
'====================================================================

   Dim strFolder As String
   Dim objFSO As Object
   Dim objFolder As Object
   Dim objFile As Object
   Dim colFiles As Object

   strFolder = TEST_FILE_PATH

   ' Create needed objects
   Dim wsh As Object  ' As Object if late-bound
   Set wsh = CreateObject("WScript.Shell")
    
   Set objFSO = CreateObject("Scripting.FileSystemObject")
   Set objFolder = objFSO.GetFolder(strFolder)

   Debug.Print "objFolder.Path = " & objFolder.Path

   Set colFiles = objFolder.Files

   For Each objFile In colFiles
       Debug.Print "objFile.Path = " & objFile.Path
   Next

   ShowSubFolders objFolder
   Debug.Print "DONE !!!"

   Set wsh = Nothing
   Set objFSO = Nothing
   Set objFolder = Nothing
   Set colFiles = Nothing

End Sub
 
Private Sub ShowSubFolders(objFolder)
'Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx

   Dim objFile As Object
   Dim objSubFolder As Object
   Dim colFolders As Object
   Dim colFiles As Object
   Dim wsh As Object  ' As Object if late-bound

   Set wsh = CreateObject("WScript.Shell")
   Set colFolders = objFolder.SubFolders
    
   For Each objSubFolder In colFolders
  
       Debug.Print "objSubFolder.Path = " & objSubFolder.Path
       Set colFiles = objSubFolder.Files
  
       For Each objFile In colFiles
           Debug.Print "objFile.Path = " & objFile.Path
       Next

       ShowSubFolders objSubFolder
   Next

   Set wsh = Nothing
   Set colFolders = Nothing

End Sub