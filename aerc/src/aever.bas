Option Compare Database
Option Explicit

Public Sub Version_Test()
    On Error GoTo 0
    Debug.Print GetEdition(Application.Version, Application.ProductCode)
End Sub

Public Function GetEdition(ByVal strAppVersion As String, ByVal strGuid As String) As String
    ' Ref: http://www.makeuseof.com/tag/monitor-vba-apps-running-slick-script/
    ' Ref: http://p2p.wrox.com/excel-vba/82653-what-best-way-get-excel-version.html
    ' Ref: http://colinlegg.wordpress.com/2013/02/02/office-edition-in-vba/
    ' Ref: https://community.spiceworks.com/topic/150065-how-to-remove-ms-office-2010-standard-registry-keys
    ' This one is for Office Home and Student 2010): {90140000-003D-0000-0000-0000000FF1CE}

    On Error GoTo PROC_ERR

    Const strERR_MSG As String = "Unable to determine edition"

    Dim strSku As String

    Debug.Print "strAppVersion=" & strAppVersion
    Debug.Print "Val(strAppVersion)=" & Val(strAppVersion)
    Debug.Print "strGuid = " & strGuid
    Select Case Val(strAppVersion)
        Case Is < 9
            GetEdition = "Pre Office 2000: " & strERR_MSG

        Case Is < 10                            ' Office 2000
            strSku = Mid$(strGuid, 4, 2)
            GetEdition = GetEdition2000_Office(strSku)

        Case Is < 11                            ' Office 2002
            strSku = Mid$(strGuid, 4, 2)
            GetEdition = GetEdition2002_Office(strSku)

        Case Is < 12                            ' Office 2003
            strSku = Mid$(strGuid, 4, 2)
            GetEdition = GetEdition2003_Office(strSku)

        Case Is < 13                            ' Office 2007
            strSku = Mid$(strGuid, 11, 4)
            GetEdition = GetEdition2007_Office(strSku)

        Case Is < 15                            ' Office 2010
            strSku = Mid$(strGuid, 11, 4)
            GetEdition = GetEdition2010_Office(strSku)

        Case Is < 16                            ' Office 2013
            strSku = Mid$(strGuid, 11, 4)
            Debug.Print "strSku=" & strSku
            GetEdition = GetEdition2013_Office(strSku)

        Case Is < 17                            ' Office 2016
            strSku = Mid$(strGuid, 11, 4)
            Debug.Print "strSku=" & strSku
            GetEdition = GetEdition2016_Office(strSku)

        Case Else
            GetEdition = "Post Office 2016: " & strERR_MSG

    End Select

PROC_EXIT:
    Exit Function

PROC_ERR:
    MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure GetEdition of Class aegit_expClass"
    GetEdition = strERR_MSG & vbNewLine & _
        "Error Number: " & CStr(Err.Number) & _
        vbNewLine & "Error Desc: " & Err.Description
 
End Function
 
Private Function GetEdition2000_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/230848/
 
    On Error GoTo 0
    Select Case strSku
        Case "00"
            GetEdition2000_Office = "Microsoft Office 2000 Premium Edition CD1"
        Case "01"
            GetEdition2000_Office = "Microsoft Office 2000 Professional Edition"
        Case "02"
            GetEdition2000_Office = "Microsoft Office 2000 Standard Edition"
        Case "03"
            GetEdition2000_Office = "Microsoft Office 2000 Small Business Edition"
        Case "04"
            GetEdition2000_Office = "Microsoft Office 2000 Premium CD2"
        Case "05"
            GetEdition2000_Office = "Office CD2 SMALL"
        Case "06" To "09", "0A" To "0F"
            GetEdition2000_Office = "(reserved)"
        Case "10"
            GetEdition2000_Office = "Microsoft Access 2000 (standalone)"
        Case "11"
            GetEdition2000_Office = "Microsoft Excel 2000 (standalone)"
        Case "12"
            GetEdition2000_Office = "Microsoft FrontPage 2000 (standalone)"
        Case "13"
            GetEdition2000_Office = "Microsoft PowerPoint 2000 (standalone)"
        Case "14"
            GetEdition2000_Office = "Microsoft Publisher 2000 (standalone)"
        Case "15"
            GetEdition2000_Office = "Office Server Extensions"
        Case "16"
            GetEdition2000_Office = "Microsoft Outlook 2000 (standalone)"
        Case "17"
            GetEdition2000_Office = "Microsoft Word 2000 (standalone)"
        Case "18"
            GetEdition2000_Office = "Microsoft Access 2000 runtime version"
        Case "19"
            GetEdition2000_Office = "FrontPage Server Extensions"
        Case "1A"
            GetEdition2000_Office = "Publisher Standalone OEM"
        Case "1B"
            GetEdition2000_Office = "DMMWeb"
        Case "1C"
            GetEdition2000_Office = "FP WECCOM"
        Case "1D" To "1F"
            GetEdition2000_Office = "(reserved standalone SKUs)"
        Case "20" To "29", "2A" To "2F"
            GetEdition2000_Office = "Office Language Packs"
        Case "30" To "39", "3A" To "3F"
            GetEdition2000_Office = "Proofing Tools Kit(s)"
        Case "40"
            GetEdition2000_Office = "Publisher Trial CD"
        Case "41"
            GetEdition2000_Office = "Publisher Trial Web"
        Case "42"
            GetEdition2000_Office = "SBB"
        Case "43"
            GetEdition2000_Office = "SBT"
        Case "44"
            GetEdition2000_Office = "SBT CD2"
        Case "45"
            GetEdition2000_Office = "SBTART"
        Case "46"
            GetEdition2000_Office = "Web Components"
        Case "47"
            GetEdition2000_Office = "VP Office CD2 with LVP"
        Case "48"
            GetEdition2000_Office = "VP PUB with LVP"
        Case "49"
            GetEdition2000_Office = "VP PUB with LVP OEM"
        Case "4F"
            GetEdition2000_Office = "Access 2000 SR-1 Run-Time Minimum"
        Case Else
            MsgBox "Error: GetEdition2000_Office", vbCritical, "ERROR"
    End Select
End Function
 
Private Function GetEdition2002_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/302663/
 
    On Error GoTo 0
    Select Case strSku
        Case "11"
            GetEdition2002_Office = "Microsoft Office XP Professional"
        Case "12"
            GetEdition2002_Office = "Microsoft Office XP Standard"
        Case "13"
            GetEdition2002_Office = "Microsoft Office XP Small Business"
        Case "14"
            GetEdition2002_Office = "Microsoft Office XP Web Server"
        Case "15"
            GetEdition2002_Office = "Microsoft Access 2002"
        Case "16"
            GetEdition2002_Office = "Microsoft Excel 2002"
        Case "17"
            GetEdition2002_Office = "Microsoft FrontPage 2002"
        Case "18"
            GetEdition2002_Office = "Microsoft PowerPoint 2002"
        Case "19"
            GetEdition2002_Office = "Microsoft Publisher 2002"
        Case "1A"
            GetEdition2002_Office = "Microsoft Outlook 2002"
        Case "1B"
            GetEdition2002_Office = "Microsoft Word 2002"
        Case "1C"
            GetEdition2002_Office = "Microsoft Access 2002 Runtime"
        Case "1D"
            GetEdition2002_Office = "Microsoft FrontPage Server Extensions 2002"
        Case "1E"
            GetEdition2002_Office = "Microsoft Office Multilingual User Interface Pack"
        Case "1F"
            GetEdition2002_Office = "Microsoft Office Proofing Tools Kit"
        Case "20"
            GetEdition2002_Office = "System Files Update"
        Case "22"
            GetEdition2002_Office = "unused"
        Case "23"
            GetEdition2002_Office = "Microsoft Office Multilingual User Interface Pack Wizard"
        Case "24"
            GetEdition2002_Office = "Microsoft Office XP Resource Kit"
        Case "25"
            GetEdition2002_Office = "Microsoft Office XP Resource Kit Tools (download from Web)"
        Case "26"
            GetEdition2002_Office = "Microsoft Office Web Components"
        Case "27"
            GetEdition2002_Office = "Microsoft Project 2002"
        Case "28"
            GetEdition2002_Office = "Microsoft Office XP Professional with FrontPage"
        Case "29"
            GetEdition2002_Office = "Microsoft Office XP Professional Subscription"
        Case "2A"
            GetEdition2002_Office = "Microsoft Office XP Small Business Edition Subscription"
        Case "2B"
            GetEdition2002_Office = "Microsoft Publisher 2002 Deluxe Edition"
        Case "2F"
            GetEdition2002_Office = "Standalone IME (JPN Only)"
        Case "30"
            GetEdition2002_Office = "Microsoft Office XP Media Content"
        Case "31"
            GetEdition2002_Office = "Microsoft Project 2002 Web Client"
        Case "32"
            GetEdition2002_Office = "Microsoft Project 2002 Web Server"
        Case "33"
            GetEdition2002_Office = "Microsoft Office XP PIPC1 (Pre Installed PC) (JPN Only)"
        Case "34"
            GetEdition2002_Office = "Microsoft Office XP PIPC2 (Pre Installed PC) (JPN Only)"
        Case "35"
            GetEdition2002_Office = "Microsoft Office XP Media Content Deluxe"
        Case "3A"
            GetEdition2002_Office = "Project 2002 Standard"
        Case "3B"
            GetEdition2002_Office = "Project 2002 Professional"
        Case "51"
            GetEdition2002_Office = "Microsoft Office Visio Professional 2003"
        Case "54"
            GetEdition2002_Office = "Microsoft Office Visio Standard 2003"
        Case Else
            MsgBox "Error: GetEdition2002_Office", vbCritical, "ERROR"
    End Select
End Function
 
Private Function GetEdition2003_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/832672/
 
    On Error GoTo 0
    Select Case strSku
        Case "11"
            GetEdition2003_Office = "Microsoft Office Professional Enterprise Edition 2003"
        Case "12"
            GetEdition2003_Office = "Microsoft Office Standard Edition 2003"
        Case "13"
            GetEdition2003_Office = "Microsoft Office Basic Edition 2003"
        Case "14"
            GetEdition2003_Office = "Microsoft Windows SharePoint Services 2.0"
        Case "15"
            GetEdition2003_Office = "Microsoft Office Access 2003"
        Case "16"
            GetEdition2003_Office = "Microsoft Office Excel 2003"
        Case "17"
            GetEdition2003_Office = "Microsoft Office FrontPage 2003"
        Case "18"
            GetEdition2003_Office = "Microsoft Office PowerPoint 2003"
        Case "19"
            GetEdition2003_Office = "Microsoft Office Publisher 2003"
        Case "1A"
            GetEdition2003_Office = "Microsoft Office Outlook Professional 2003"
        Case "1B"
            GetEdition2003_Office = "Microsoft Office Word 2003"
        Case "1C"
            GetEdition2003_Office = "Microsoft Office Access 2003 Runtime"
        Case "1E"
            GetEdition2003_Office = "Microsoft Office 2003 User Interface Pack"
        Case "1F"
            GetEdition2003_Office = "Microsoft Office 2003 Proofing Tools"
        Case "23"
            GetEdition2003_Office = "Microsoft Office 2003 Multilingual User Interface Pack"
        Case "24"
            GetEdition2003_Office = "Microsoft Office 2003 Resource Kit"
        Case "26"
            GetEdition2003_Office = "Microsoft Office XP Web Components"
        Case "2E"
            GetEdition2003_Office = "Microsoft Office 2003 Research Service SDK"
        Case "44"
            GetEdition2003_Office = "Microsoft Office InfoPath 2003"
        Case "83"
            GetEdition2003_Office = "Microsoft Office 2003 HTML Viewer"
        Case "92"
            GetEdition2003_Office = "Windows SharePoint Services 2.0 English Template Pack"
        Case "93"
            GetEdition2003_Office = "Microsoft Office 2003 English Web Parts and Components"
        Case "A1"
            GetEdition2003_Office = "Microsoft Office OneNote 2003"
        Case "A4"
            GetEdition2003_Office = "Microsoft Office 2003 Web Components"
        Case "A5"
            GetEdition2003_Office = "Microsoft SharePoint Migration Tool 2003"
        Case "AA"
            GetEdition2003_Office = "Microsoft Office PowerPoint 2003 Presentation Broadcast"
        Case "AB"
            GetEdition2003_Office = "Microsoft Office PowerPoint 2003 Template Pack 1"
        Case "AC"
            GetEdition2003_Office = "Microsoft Office PowerPoint 2003 Template Pack 2"
        Case "AD"
            GetEdition2003_Office = "Microsoft Office PowerPoint 2003 Template Pack 3"
        Case "AE"
            GetEdition2003_Office = "Microsoft Organization Chart 2.0"
        Case "CA"
            GetEdition2003_Office = "Microsoft Office Small Business Edition 2003"
        Case "D0"
            GetEdition2003_Office = "Microsoft Office Access 2003 Developer Extensions"
        Case "DC"
            GetEdition2003_Office = "Microsoft Office 2003 Smart Document SDK"
        Case "E0"
            GetEdition2003_Office = "Microsoft Office Outlook Standard 2003"
        Case "E3"
            GetEdition2003_Office = "Microsoft Office Professional Edition 2003 (with InfoPath 2003)"
        Case "FD"
            GetEdition2003_Office = "Microsoft Office Outlook 2003 (distributed by MSN)"
        Case "FF"
            GetEdition2003_Office = "Microsoft Office 2003 Edition Language Interface Pack"
        Case "F8"
            GetEdition2003_Office = "Remove Hidden Data Tool"
        Case "3A"
            GetEdition2003_Office = "Microsoft Office Project Standard 2003"
        Case "3B"
            GetEdition2003_Office = "Microsoft Office Project Professional 2003"
        Case "32"
            GetEdition2003_Office = "Microsoft Office Project Server 2003"
        Case "51"
            GetEdition2003_Office = "Microsoft Office Visio Professional 2003"
        Case "52"
            GetEdition2003_Office = "Microsoft Office Visio Viewer 2003"
        Case "53"
            GetEdition2003_Office = "Microsoft Office Visio Standard 2003"
        Case "55"
            GetEdition2003_Office = "Microsoft Office Visio for Enterprise Architects 2003"
        Case "5E"
            GetEdition2003_Office = "Microsoft Office Visio 2003 Multilingual User Interface Pack"
        Case Else
            MsgBox "Error: GetEdition2003_Office", vbCritical, "ERROR"
    End Select
End Function
 
Private Function GetEdition2007_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/928516/
 
    On Error GoTo 0
    Select Case strSku
        Case "0011"
            GetEdition2007_Office = "Microsoft Office Professional Plus 2007"
        Case "0012"
            GetEdition2007_Office = "Microsoft Office Standard 2007"
        Case "0013"
            GetEdition2007_Office = "Microsoft Office Basic 2007"
        Case "0014"
            GetEdition2007_Office = "Microsoft Office Professional 2007"
        Case "0015"
            GetEdition2007_Office = "Microsoft Office Access 2007"
        Case "0016"
            GetEdition2007_Office = "Microsoft Office Excel 2007"
        Case "0017"
            GetEdition2007_Office = "Microsoft Office SharePoint Designer 2007"
        Case "0018"
            GetEdition2007_Office = "Microsoft Office PowerPoint 2007"
        Case "0019"
            GetEdition2007_Office = "Microsoft Office Publisher 2007"
        Case "001A"
            GetEdition2007_Office = "Microsoft Office Outlook 2007"
        Case "001B"
            GetEdition2007_Office = "Microsoft Office Word 2007"
        Case "001C"
            GetEdition2007_Office = "Microsoft Office Access Runtime 2007"
        Case "0020"
            GetEdition2007_Office = "Microsoft Office Compatibility Pack for Word, Excel, and PowerPoint 2007 File Formats"
        Case "0026"
            GetEdition2007_Office = "Microsoft Expression Web"
        Case "0029"
            GetEdition2007_Office = "Microsoft Office Excel 2007"
        Case "002B"
            GetEdition2007_Office = "Microsoft Office Word 2007"
        Case "002E"
            GetEdition2007_Office = "Microsoft Office Ultimate 2007"
        Case "002F"
            GetEdition2007_Office = "Microsoft Office Home and Student 2007"
        Case "0030"
            GetEdition2007_Office = "Microsoft Office Enterprise 2007"
        Case "0031"
            GetEdition2007_Office = "Microsoft Office Professional Hybrid 2007"
        Case "0033"
            GetEdition2007_Office = "Microsoft Office Personal 2007"
        Case "0035"
            GetEdition2007_Office = "Microsoft Office Professional Hybrid 2007"
        Case "0037"
            GetEdition2007_Office = "Microsoft Office PowerPoint 2007"
        Case "003A"
            GetEdition2007_Office = "Microsoft Office Project Standard 2007"
        Case "003B"
            GetEdition2007_Office = "Microsoft Office Project Professional 2007"
        Case "0044"
            GetEdition2007_Office = "Microsoft Office InfoPath 2007"
        Case "0051"
            GetEdition2007_Office = "Microsoft Office Visio Professional 2007"
        Case "0052"
            GetEdition2007_Office = "Microsoft Office Visio Viewer 2007"
        Case "0053"
            GetEdition2007_Office = "Microsoft Office Visio Standard 2007"
        Case "00A1"
            GetEdition2007_Office = "Microsoft Office OneNote 2007"
        Case "00A3"
            GetEdition2007_Office = "Microsoft Office OneNote Home Student 2007"
        Case "00A7"
            GetEdition2007_Office = "Calendar Printing Assistant for Microsoft Office Outlook 2007"
        Case "00A9"
            GetEdition2007_Office = "Microsoft Office InterConnect 2007"
        Case "00AF"
            GetEdition2007_Office = "Microsoft Office PowerPoint Viewer 2007 (English)"
        Case "00B0"
            GetEdition2007_Office = "The Microsoft Save as PDF add-in"
        Case "00B1"
            GetEdition2007_Office = "The Microsoft Save as XPS add-in"
        Case "00B2"
            GetEdition2007_Office = "The Microsoft Save as PDF or XPS add-in"
        Case "00BA"
            GetEdition2007_Office = "Microsoft Office Groove 2007"
        Case "00CA"
            GetEdition2007_Office = "Microsoft Office Small Business 2007"
        Case "00E0"
            GetEdition2007_Office = "Microsoft Office Outlook 2007"
        Case "10D7"
            GetEdition2007_Office = "Microsoft Office InfoPath Forms Services"
        Case "110D"
            GetEdition2007_Office = "Microsoft Office SharePoint Server 2007"
        Case "1122"
            GetEdition2007_Office = "Windows SharePoint Services Developer Resources 1.2"
        Case "0010"
            GetEdition2007_Office = "SKU - Microsoft Software Update for Web Folders (English) 12"
        Case Else
            MsgBox "Error: GetEdition2007_Office", vbCritical, "ERROR"
    End Select
End Function
 
Private Function GetEdition2010_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/2186281
 
    On Error GoTo 0
    Select Case strSku
        Case "0011"
            GetEdition2010_Office = "Microsoft Office Professional Plus 2010"
        Case "011D"
            GetEdition2010_Office = "Microsoft Office Professional Plus Subscription 2010 "
        Case "0012"
            GetEdition2010_Office = "Microsoft Office Standard 2010"
        Case "0013"
            GetEdition2010_Office = "Microsoft Office Home and Business 2010"
        Case "0014"
            GetEdition2010_Office = "Microsoft Office Professional 2010"
        Case "0015"
            GetEdition2010_Office = "Microsoft Access 2010"
        Case "0016"
            GetEdition2010_Office = "Microsoft Excel 2010"
        Case "0017"
            GetEdition2010_Office = "Microsoft SharePoint Designer 2010"
        Case "0018"
            GetEdition2010_Office = "Microsoft PowerPoint 2010"
        Case "0019"
            GetEdition2010_Office = "Microsoft Publisher 2010"
        Case "001A"
            GetEdition2010_Office = "Microsoft Outlook 2010"
        Case "001B"
            GetEdition2010_Office = "Microsoft Word 2010"
        Case "001C"
            GetEdition2010_Office = "Microsoft Access Runtime 2010"
        Case "001F"
            GetEdition2010_Office = "Microsoft Office Proofing Tools Kit Compilation 2010"
        Case "002F"
            GetEdition2010_Office = "Microsoft Office Home and Student 2010"
        Case "003A"
            GetEdition2010_Office = "Microsoft Project Standard 2010"
        Case "003B"
            GetEdition2010_Office = "Microsoft Project Professional 2010"
        Case "0044"
            GetEdition2010_Office = "Microsoft InfoPath 2010"
        Case "0052"
            GetEdition2010_Office = "Microsoft Visio Viewer 2010"
        Case "0057"
            GetEdition2010_Office = "Microsoft Visio 2010"
        Case "007A"
            GetEdition2010_Office = "Microsoft Outlook Connector"
        Case "008B"
            GetEdition2010_Office = "Microsoft Office Small Business Basics 2010"
        Case "00A1"
            GetEdition2010_Office = "Microsoft OneNote 2010"
        Case "00AF"
            GetEdition2010_Office = "Microsoft PowerPoint Viewer 2010"
        Case "00BA"
            GetEdition2010_Office = "Microsoft Office SharePoint Workspace 2010"
        Case "110D"
            GetEdition2010_Office = "Microsoft Office SharePoint Server 2010"
        Case "110F"
            GetEdition2010_Office = "Microsoft Project Server 2010"
        Case Else
            MsgBox "Error: GetEdition2010_Office", vbCritical, "ERROR"
            Debug.Print "strSku = " & strSku
    End Select
End Function
 
Private Function GetEdition2013_Office(ByVal strSku As String) As String
    ' Ref: http://support.microsoft.com/kb/2786054
 
    On Error GoTo 0
    Debug.Print "GetEdition2013_Office strSku=" & strSku
    Select Case strSku
        Case "0011"
            GetEdition2013_Office = "Microsoft Office Professional Plus 2013"
        Case "0012"
            GetEdition2013_Office = "Microsoft Office Standard 2013"
        Case "0013"
            GetEdition2013_Office = "Microsoft Office Home and Business 2013"
        Case "0014"
            GetEdition2013_Office = "Microsoft Office Professional 2013"
        Case "0015"
            GetEdition2013_Office = "Microsoft Access 2013"
        Case "0016"
            GetEdition2013_Office = "Microsoft Excel 2013"
        Case "0017"
            GetEdition2013_Office = "Microsoft SharePoint Designer 2013"
        Case "0018"
            GetEdition2013_Office = "Microsoft PowerPoint 2013"
        Case "0019"
            GetEdition2013_Office = "Microsoft Publisher 2013"
        Case "001A"
            GetEdition2013_Office = "Microsoft Outlook 2013"
        Case "001B"
            GetEdition2013_Office = "Microsoft Word 2013"
        Case "001C"
            GetEdition2013_Office = "Microsoft Access Runtime 2013"
        Case "001F"
            GetEdition2013_Office = "Microsoft Office Proofing Tools Kit Compilation 2013"
        Case "002F"
            GetEdition2013_Office = "Microsoft Office Home and Student 2013"
        Case "003A"
            GetEdition2013_Office = "Microsoft Project Standard 2013"
        Case "003B"
            GetEdition2013_Office = "Microsoft Project Professional 2013"
        Case "0044"
            GetEdition2013_Office = "Microsoft InfoPath 2013"
        Case "0051"
            GetEdition2013_Office = "Microsoft Visio Professional 2013"
        Case "0053"
            GetEdition2013_Office = "Microsoft Visio Standard 2013"
        Case "00A1"
            GetEdition2013_Office = "Microsoft OneNote 2013"
        Case "00BA"
            GetEdition2013_Office = "Microsoft Office SharePoint Workspace 2013"
        Case "110D"
            GetEdition2013_Office = "Microsoft Office SharePoint Server 2013"
        Case "110F"
            GetEdition2013_Office = "Microsoft Project Server 2013"
        Case "012B"
            GetEdition2013_Office = "Microsoft Lync 2013"
        Case Else
            MsgBox "Error: GetEdition2013_Office", vbCritical, "ERROR"
    End Select
End Function

Private Function GetEdition2016_Office(ByVal strSku As String) As String
    ' Ref: https://support.microsoft.com/en-us/kb/3120274
 
    On Error GoTo 0
    Debug.Print "GetEdition2016_Office strSku=" & strSku
    Select Case strSku
        Case "0011"
            GetEdition2016_Office = "Microsoft Office Professional Plus 2016"
        Case "0012"
            GetEdition2016_Office = "Microsoft Office Standard 2016"
        Case "0015"
            GetEdition2016_Office = "Microsoft Access 2016"
        Case "0016"
            GetEdition2016_Office = "Microsoft Excel 2016"
        Case "0018"
            GetEdition2016_Office = "Microsoft PowerPoint 2016"
        Case "0019"
            GetEdition2016_Office = "Microsoft Publisher 2016"
        Case "001A"
            GetEdition2016_Office = "Microsoft Outlook 2016"
        Case "001B"
            GetEdition2016_Office = "Microsoft Word 2016"
        Case "001F"
            GetEdition2016_Office = "Microsoft Office Proofing Tools Kit Compilation 2016"
        Case "003A"
            GetEdition2016_Office = "Microsoft Project Standard 2016"
        Case "003B"
            GetEdition2016_Office = "Microsoft Project Professional 2016"
        Case "0051"
            GetEdition2016_Office = "Microsoft Visio Professional 2016"
        Case "0053"
            GetEdition2016_Office = "Microsoft Visio Standard 2016"
        Case "00A1"
            GetEdition2016_Office = "Microsoft OneNote 2016"
        Case "00BA"
            GetEdition2016_Office = "Microsoft Office OneDrive for Business 2016"
        Case "110D"
            GetEdition2016_Office = "Microsoft Office SharePoint Server 2016"
        Case "012B"
            GetEdition2016_Office = "Microsoft Skype for Business 2016"
        Case Else
            MsgBox "Error: GetEdition2016_Office", vbCritical, "ERROR"
    End Select
End Function