Option Compare Database
Option Explicit

Private mintSubFolderLevel As Integer
Private Const OUTPUT_FOLDERS_ONLY As String = "C:\TEMP\OutputListOfFolders.txt"
Private Const OUTPUT_FOLDERS_FILES As String = "C:\TEMP\OutputListOfFoldersFiles.txt"
Private Const LEVEL_ARROW As String = ">"
Private fle As Integer
Private fle2 As Integer
'

Public Sub TestListFileSystemRecursively()

    fle = FreeFile()    ' Create output file for folders only
    Open OUTPUT_FOLDERS_ONLY For Output As #fle
    Close fle
    Dim TEST_FILE_PATH As String

    Open OUTPUT_FOLDERS_ONLY For Append As #fle
    'TEST_FILE_PATH = "C:\"
    'TEST_FILE_PATH = "C:\PFE\"
    'TEST_FILE_PATH = "C:\Users\"
    'TEST_FILE_PATH = "C:\Apps\"
    'TEST_FILE_PATH = "C:\__DATA_DELETION__"
    TEST_FILE_PATH = "C:\TEMP\"
    mintSubFolderLevel = 1
    ListFileSystemRecursively TEST_FILE_PATH, varDebug:="DebugIt"
    Close fle
    '
    fle2 = FreeFile()    ' Create output file for folders only
    Open OUTPUT_FOLDERS_FILES For Output As #fle2
    Close fle2
    Open OUTPUT_FOLDERS_FILES For Append As #fle2
    TEST_FILE_PATH = "C:\TEMP\"
    mintSubFolderLevel = 1
    ListFileSystemRecursively TEST_FILE_PATH, varListFiles:=True, varDebug:="DebugIt"
    Close fle
    '
End Sub

Public Function fLevelArrow(intNum As Integer) As String
    Dim i As Integer
    Dim str As String
    str = LEVEL_ARROW
    For i = 1 To intNum
        str = str & LEVEL_ARROW
    Next
    fLevelArrow = str
End Function

Public Sub ListFileSystemRecursively(strRootPathName As String, _
                Optional varListFiles As Variant, _
                Optional varDebug As Variant)
' Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx
'==============================================================================
' Purpose:  List File System Recursively
' Author:   Peter Ennis
' Date:     February 10, 2011
' Comment:  Fix to work in VBA. Based on MSDN sample for WScript
' Requires: Late binding does not need reference to Microsoft Scripting Runtime
'==============================================================================

    Dim strFolder As String
    Dim objFSO As Object
    Dim objFolder As Object
    Dim objFile As Object
    Dim colFiles As Object

    strFolder = strRootPathName

    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFolder = objFSO.GetFolder(strFolder)

    Set colFiles = objFolder.Files

    If Not IsMissing(varListFiles) Then
        Debug.Print "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") & " " & LEVEL_ARROW & " " & objFolder.Path
        Print #fle, "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") & " " & LEVEL_ARROW & " " & objFolder.Path
        'Debug.Print "ListFileSystemRecursively varListFiles=" & varListFiles
        For Each objFile In colFiles
            Debug.Print "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFile.Path), "000") & " " & LEVEL_ARROW & " " & objFile.Path
            Print #fle, "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFile.Path), "000") & " " & LEVEL_ARROW & " " & objFile.Path
        Next
        ShowSubFolders objFolder, varListFilesShow:=varListFiles, varDebugShow:=varDebug
    Else
        Debug.Print "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") & " " & LEVEL_ARROW & " " & objFolder.Path
        Print #fle, "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") & " " & LEVEL_ARROW & " " & objFolder.Path
        'Debug.Print "ListFileSystemRecursively varListFiles IS MISSING"
        ShowSubFolders objFolder, varListFilesShow:=varListFiles, varDebugShow:=varDebug
    End If
    Debug.Print "DONE !!!"
    Print #fle, "DONE !!!"

    Set objFSO = Nothing
    Set objFolder = Nothing
    Set colFiles = Nothing

End Sub
 
Public Sub ShowSubFolders(objFolder As Object, _
                Optional varListFilesShow As Variant, _
                Optional varDebugShow As Variant)
' Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx

    On Error GoTo PROC_ERR

    Dim objFile As Object
    Dim objSubFolder As Object
    Dim colFiles As Object
    
    Dim colFolders As Object
    Set colFolders = objFolder.SubFolders

    'Debug.Print mintSubFolderLevel
    For Each objSubFolder In colFolders

        Set colFiles = objSubFolder.Files

        If Not IsMissing(varListFilesShow) Then
            'Debug.Print "ShowSubFolders varListFilesShow=" & varListFilesShow
            mintSubFolderLevel = mintSubFolderLevel + 1
            For Each objFile In colFiles
                Debug.Print "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFile.Path), "000") & " " & LEVEL_ARROW & " " & objFile.Path
                Print #fle, "Top Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFile.Path), "000") & " " & LEVEL_ARROW & " " & objFile.Path
            Next
            ShowSubFolders objSubFolder, varListFilesShow:=varListFilesShow, varDebugShow:=varDebugShow
        Else
            'Debug.Print "ShowSubFolders varListFilesShow IS MISSING"
            mintSubFolderLevel = mintSubFolderLevel + 1
            If Not IsMissing(varDebugShow) Then _
                Debug.Print "Sub Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") _
                                            & " " & fLevelArrow(mintSubFolderLevel) & " " & objSubFolder.Path
            Print #fle, "Sub Level = " & Format(mintSubFolderLevel, "00") & " Len = " & Format(Len(objFolder.Path), "000") _
                                            & " " & fLevelArrow(mintSubFolderLevel) & " " & objSubFolder.Path
            ShowSubFolders objSubFolder, varListFilesShow:=varListFilesShow, varDebugShow:=varDebugShow
        End If
        mintSubFolderLevel = mintSubFolderLevel - 1
    Next

PROC_EXIT:
    Set colFolders = Nothing
    'PopCallStack
    Exit Sub

PROC_ERR:
    If Err = 70 Then        ' Permission denied
        Err.Clear
        Resume PROC_EXIT
    Else
        MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure ShowSubFolders of Module aefs"
        'If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure ShowSubFolders of Module aefs"
        'GlobalErrHandler
        Resume PROC_EXIT
    End If
End Sub