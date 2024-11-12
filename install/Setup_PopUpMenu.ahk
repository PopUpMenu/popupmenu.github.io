; -------------------------------------------
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
; -------------------------------------------
#SingleInstance, force
; -------------------------------------------
#NoTrayIcon
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Porgram Installer
;
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ (Line 22) Installer Number and Number of Install Zip Files
InstallerNumber := "n2shceah"
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ (Line 22) Installer Number and Number of Install Zip Files
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [FUNCTIONS]
; -------------------------------------------
ArrayAdd(ThisArray, AddThis, ThisPos) ; ThisArray, AddThis, ThisPos > ThisArray
{
  ; -------------------------------------------
  if !ThisPos
  {
    ThisPos := "End"
  }
  ; -------------------------------------------
  if AddThis
  {
    CheckThis := ThisArray[1]
    if CheckThis
    {
      if (ThisPos == "End")
      {
        ThisArray.Push(AddThis) ; Adds (AddThis) to End
      }
      else
      {
        if (ThisPos == 0)
        {
          ThisPos := 1
        }
        ThisArray.InsertAt(ThisPos, AddThis) ; Adds (AddThis) at (ThisPos)
      }
    } ; End if CheckThis
    else
    {
      ThisArray := []
      ThisArray[1] := AddThis
    } ; End else
  } ; End if AddThis
  return ThisArray
} ; [End] ArrayAdd(ThisArray, AddThis, ThisPos) ; ThisArray, AddThis, ThisPos > ThisArray
; -------------------------------------------
ArrayFromFile(FilePath) ; > Array
{
  ; -------------------------------------------
  FileRead, FilePathString, %FilePath%
  FilePathArray := StrSplit(FilePathString, "`n", "`n")
  ReturnArray := []
  for Index, ThisLine in FilePathArray
  {
    ThisLine := StrReplace(ThisLine, "`n", "")
    ThisLine := StrReplace(ThisLine, "`r", "")
    ReturnArray.Push(ThisLine)
  }
  ; -------------------------------------------
  return ReturnArray
}
; -------------------------------------------
CancelInstall(ErrorNum, ThisType, ThisApp, ThisLang) ; CancelInstall(["E1-E6"/"EX"], ["Program"/"Plugin"], ThisApp, ThisLang) ; > ExitApp
{
  ; -------------------------------------------
  global MessageShow := 0 ; Show
  SetTimer, Label_Message, Off
  ; -------------------------------------------
  if (ErrorNum == "EX") ; User Pressed Canceled
  {
    if (ThisType == "Program")
    {
      ; -------------------------------------------
      CheckProgramFilesDir := A_ProgramFiles "\PopUpMenu_PUM"
      if FileExist(CheckProgramFilesDir)
      {
        ; -------------------------------------------
        DeleteFolderPopUpMenu()
        ; -------------------------------------------
      } ; [End] if FileExist(CheckProgramFilesDir)
    } ; [End] if (ThisType == "Program")
    else if (ThisType == "Plugin")
    {
      ; -------------------------------------------
      CheckProgramFilesDir := A_ProgramFiles "\PopUpMenu_PUM\menu\mnu\" ThisApp "\" ThisLang
      if FileExist(CheckProgramFilesDir)
      {
        ; -------------------------------------------
        FileRemoveDir, %CheckProgramFilesDir%, 1
        ; -------------------------------------------
      } ; [End] if FileExist(CheckProgramFilesDir)
      ; -------------------------------------------
    } ; [End] else if (ThisType == "Plugin")
    ; -------------------------------------------
  } ; [End] if (ErrorNum == "EX") ; User Pressed Canceled
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ExitApp
  ; -------------------------------------------
} ; [End] CancelInstall(ErrorNum, ThisType, ThisApp, ThisLang)
; -------------------------------------------
CheckHasAdminRights()
{
  ; -------------------------------------------
  TOKEN_QUERY := 0x0008
  TokenElevationTypeDefault := 1
  TokenElevationTypeFull := 2
  TokenElevationTypeLimited := 3
  TokenType := 8
  TokenElevationType := 18
  ; -------------------------------------------
  TokenInformationClass := TokenElevationType
  DllCall("SetLastError", "UInt", 0)
  ret := DllCall("Advapi32.dll\OpenProcessToken", "UInt", DllCall("GetCurrentProcess"), "UInt", TOKEN_QUERY, "UIntP", hToken)
  ; -------------------------------------------
  DllCall("SetLastError", "UInt", 0)
  DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", TokenInformationClass, "Int", 0, "Int", 0, "UIntP", ReturnLength)
  ; -------------------------------------------
  sizeof_elevationType:=VarSetCapacity(elevationType, ReturnLength, 0)
  DllCall("SetLastError", "UInt", 0)
  DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", TokenInformationClass, "UIntP", elevationType, "Int", sizeof_elevationType, "UIntP", ReturnLength)
  ; -------------------------------------------
  if (elevationType=TokenElevationTypeDefault)
  {
    ThisUserHasAdminRights := 0
  }
  else if (elevationType=TokenElevationTypeFull)
  {
    ThisUserHasAdminRights := 1
  }
  else if (elevationType=TokenElevationTypeLimited)
  {
    ThisUserHasAdminRights := 1
  }
  else
  {
    ThisUserHasAdminRights := 0
  }
  if (hToken)
  {
    DllCall("CloseHandle", "UInt", hToken)
  }
  ; -------------------------------------------
  return ThisUserHasAdminRights
  ; -------------------------------------------
} ; [End] CheckHasAdminRights()
; -------------------------------------------
DeleteFolderPopUpMenu()
{
  ; -------------------------------------------
  FolderPopUpMenu := A_ProgramFiles "\PopUpMenu_Pum"
  FileRemoveDir, %FolderPopUpMenu% , 1
  BreakTime := A_TickCount + 60000 ; 1 Minute
  while FileExist(FolderPopUpMenu)
  {
    if (BreakTime > A_TickCount)
    {
      break
    }
  }
  ; -------------------------------------------
}
; -------------------------------------------
DoUnZip(ZipFile)
{
  ; -------------------------------------------
  UnZipDir := A_ProgramFiles
  psh := ComObjCreate("Shell.Application")
  psh.Namespace( UnZipDir ).CopyHere( psh.Namespace( ZipFile ).items, 4|16 )
  ; -------------------------------------------
}
; -------------------------------------------
DownloadFile(ThisUrl, ThisFile) ; ThisUrl, ThisFile > File Downloaded OK [0/1]
{
  ; -------------------------------------------
  FileOk := 1
  ; -------------------------------------------
  FileEncoding, UTF-8
  URLDownloadToFile, %ThisUrl%, %ThisFile%
  ; -------------------------------------------
  if FileExist(ThisFile)
  {
    ; -------------------------------------------
    ThisFileArray := ArrayFromFile(ThisFile) ; > Array
    ; -------------------------------------------
    for Index, ThisLine in ThisFileArray
    {
      ; -------------------------------------------
      StringLower, ThisLine, ThisLine
      ; -------------------------------------------
      if (InStr(ThisLine, "html>") > 0) ; (Line 1 Github 404 page) <!DOCTYPE html>
      {
        ; -------------------------------------------
        FileOk := 0
        if FileExist(ThisFile)
        {
          FileDelete, %ThisFile%
          Sleep, 100
        }
        ; -------------------------------------------
        break
        ; -------------------------------------------
      } ; [End] if (InStr(ThisLine, "doctype") > 0 && InStr(ThisLine, "html>") > 0) ; (Line 1 Github 404 page) <!DOCTYPE html>
      ; -------------------------------------------
    } ; [End] for Index, ThisLine in ThisFileArray
  }
  else
  {
    ; -------------------------------------------
    FileOk := 0
    ; -------------------------------------------
  }
  ; -------------------------------------------  
	return FileOk
  ; -------------------------------------------
} ; [End] DownloadFile(ThisUrl, ThisFile) ; ThisUrl, ThisFile > File Downloaded [OK] [0/1]
; -------------------------------------------
DownloadSupportProcessBar(ArrayUrl, ArrayFile)
{
  ; -------------------------------------------
  Progress, b cbbe37f0 w450 h30
  ; -------------------------------------------
  TotalFileSize := 0
  ; -------------------------------------------
  TotalFileSize := 0
  for Index, ThisUrl in ArrayUrl
  {
    ; -------------------------------------------
    ThisFileSize := HttpQueryInfo(ThisUrl, 5)
    TotalFileSize := TotalFileSize + ThisFileSize
    ; -------------------------------------------
  }
  ; -------------------------------------------
  SetTimer, SupportDownloadProgressBar, 50
  ; -------------------------------------------
  for Index, ThisFile in ArrayFile
  {
    ; -------------------------------------------
    ThisUrl := ArrayUrl[Index]
    UrlDownloadToFile, %ThisUrl%, %ThisFile%
    ; -------------------------------------------
  }
  ; -------------------------------------------
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  SupportDownloadProgressBar:
  {
    ; -------------------------------------------
    ProcessBarSize := GetPercentArray(ArrayFile, TotalFileSize) ; > ThisPercent
    Progress, %ProcessBarSize% ; Set the position of the bar to 50%.
    ; -------------------------------------------
    if (ProcessBarSize >= 100)
    {
      Progress, 100
      Sleep, 100
      Progress, Off
      SetTimer, SupportDownloadProgressBar, Off
    }
  }
  return
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
} ; [End] DownloadProcessBar
; -------------------------------------------
Email_Info() ; > ReturnArray := [(1)BoardID, (2)SystemName, (3)WindowsVersion, (4)IpPublic, (5)IpPrivate, (6)HasAdminRights, (7)ThisCity, (8)ThisRegion, (9)ThisPostal, (10)ThisCountry, (11)ThisTimeZone, (12)LangPopUpMenu, (13)LangSystem, (14)ContactName, (15)ContactEmail]
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; BoardID
  ; -------------------------------------------
  (ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_BaseBoard")._NewEnum)[objMBInfo]
  BoardID := objMBInfo["SerialNumber"]
  ; -------------------------------------------
  ; BoardID
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; WindowsVersion
  ; -------------------------------------------
  RegRead, WindowsVersion, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows NT\CurrentVersion, ProductName ; (360_2)(Windows Version)
  ; -------------------------------------------
  ; WindowsVersion
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; IpPublic, IpPrivate, ThisTimeZone, ThisRegion, ThisCity, ThisPostal, ThisCountry
  ; -------------------------------------------
  IpInfoArray := GetLocation() ; ReturnArray := ["IP", "TimeZone", "Region", "City", "ZipCode", "Country"]
  ; -------------------------------------------
  IpPrivate    := A_IPAddress1 ; (360_8)(Private IP)
  IpPublic     := IpInfoArray.1
  ThisTimeZone := IpInfoArray.2
  ThisRegion   := IpInfoArray.3
  ThisCity     := IpInfoArray.4
  ThisPostal   := IpInfoArray.5
  ThisCountry  := IpInfoArray.6
  ; -------------------------------------------
  ; IpPublic, IpPrivate, ThisTimeZone, ThisRegion, ThisCity, ThisPostal, ThisCountry
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; SystemName
  ; -------------------------------------------
  strComputer := "."
  objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . strComputer . "\root\cimv2")
  ; -------------------------------------------
  colSettings := objWMIService.ExecQuery("Select * from Win32_ComputerSystem")._NewEnum
  while colSettings[strCSItem]
  {
    ComputerSystem := strCSItem.Caption
  } 
  ; -------------------------------------------
  colSettings := objWMIService.ExecQuery("Select * from Win32_OperatingSystem")._NewEnum
  while colSettings[objOSItem]
  {
    OperatingSystem := objOSItem.CSName
  }
  ; -------------------------------------------
  if (OperatingSystem == ComputerSystem)
  {
    SystemName := OperatingSystem
  }
  else
  {
    SystemName := ComputerSystem " / " OperatingSystem
  }
  ; -------------------------------------------
  ; SystemName
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; HasAdminRights
  ; -------------------------------------------
  HasAdminRights := EmailInfoHasAdminRights()
  ; -------------------------------------------
  ; HasAdminRights
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; LangPopUpMenu
  ; -------------------------------------------
  File_UserLang := A_AppData "\PopUpMenu_PUM\system\File_UserLang.txt"
  ; -------------------------------------------
  if FileExist(File_UserLang)
  {
    FileReadLINE, UserLang, %File_UserLang%, 1
    Sleep, 100
    if (UserLang == "de")
    {
      LangPopUpMenu := "(de) German"
    }
    else if (UserLang == "en")
    {
      LangPopUpMenu := "(en) English"
    }
    else if (UserLang == "es")
    {
      LangPopUpMenu := "(es) Spanish"
    }
    else if (UserLang == "fr")
    {
      LangPopUpMenu := "(fr) French"
    }
    else if (UserLang == "it")
    {
      LangPopUpMenu := "(it) Italian"
    }
    else if (UserLang == "pl")
    {
      LangPopUpMenu := "(pl) Polish"
    }
    else if (UserLang == "pt")
    {
      LangPopUpMenu := "(pt) Portuguese"
    }
    else if (UserLang == "ru")
    {
      LangPopUpMenu := "(ru) Russian"
    }
    else if (UserLang == "sv")
    {
      LangPopUpMenu := "(sv) Swedish"
    }
    else if (UserLang == "tr")
    {
      LangPopUpMenu := "(tr) Turkish"
    }
    else
    {
      LangPopUpMenu := "UNKNOWN"
    }
  } ; [End] if FileExist(File_UserLang)
  else
  {
    LangPopUpMenu := "UNKNOWN"
  }
  ; -------------------------------------------
  ; LangPopUpMenu
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;    
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  { ; LangSystem
    ; -------------------------------------------
    if (A_Language == "0436")
    {
      LangSystem := "Afrikaans"
    }
    else if (A_Language == "041c")
    {
      LangSystem := "Albanian"
    }
    else if (A_Language == "0401")
    {
      LangSystem := "Arabic_Saudi_Arabia"
    }
    else if (A_Language == "0801")
    {
      LangSystem := "Arabic_Iraq"
    }
    else if (A_Language == "0c01")
    {
      LangSystem := "Arabic_Egypt"
    }
    else if (A_Language == "1001")
    {
      LangSystem := "Arabic_Libya"
    }
    else if (A_Language == "1401")
    {
      LangSystem := "Arabic_Algeria"
    }
    else if (A_Language == "1801")
    {
      LangSystem := "Arabic_Morocco"
    }
    else if (A_Language == "1c01")
    {
      LangSystem := "Arabic_Tunisia"
    }
    else if (A_Language == "2001")
    {
      LangSystem := "Arabic_Oman"
    }
    else if (A_Language == "2401")
    {
      LangSystem := "Arabic_Yemen"
    }
    else if (A_Language == "2801")
    {
      LangSystem := "Arabic_Syria"
    }
    else if (A_Language == "2c01")
    {
      LangSystem := "Arabic_Jordan"
    }
    else if (A_Language == "3001")
    {
      LangSystem := "Arabic_Lebanon"
    }
    else if (A_Language == "3401")
    {
      LangSystem := "Arabic_Kuwait"
    }
    else if (A_Language == "3801")
    {
      LangSystem := "Arabic_UAE"
    }
    else if (A_Language == "3c01")
    {
      LangSystem := "Arabic_Bahrain"
    }
    else if (A_Language == "4001")
    {
      LangSystem := "Arabic_Qatar"
    }
    else if (A_Language == "042b")
    {
      LangSystem := "Armenian"
    }
    else if (A_Language == "042c")
    {
      LangSystem := "Azeri_Latin"
    }
    else if (A_Language == "082c")
    {
      LangSystem := "Azeri_Cyrillic"
    }
    else if (A_Language == "042d")
    {
      LangSystem := "Basque"
    }
    else if (A_Language == "0423")
    {
      LangSystem := "Belarusian"
    }
    else if (A_Language == "0402")
    {
      LangSystem := "Bulgarian"
    }
    else if (A_Language == "0403")
    {
      LangSystem := "Catalan"
    }
    else if (A_Language == "0404")
    {
      LangSystem := "Chinese_Taiwan"
    }
    else if (A_Language == "0804")
    {
      LangSystem := "Chinese_PRC"
    }
    else if (A_Language == "0c04")
    {
      LangSystem := "Chinese_Hong_Kong"
    }
    else if (A_Language == "1004")
    {
      LangSystem := "Chinese_Singapore"
    }
    else if (A_Language == "1404")
    {
      LangSystem := "Chinese_Macau"
    }
    else if (A_Language == "041a")
    {
      LangSystem := "Croatian"
    }
    else if (A_Language == "0405")
    {
      LangSystem := "Czech"
    }
    else if (A_Language == "0406")
    {
      LangSystem := "Danish"
    }
    else if (A_Language == "0413")
    {
      LangSystem := "Dutch_Standard"
    }
    else if (A_Language == "0813")
    {
      LangSystem := "Dutch_Belgian"
    }
    else if (A_Language == "0409")
    {
      LangSystem := "English_United_States"
    }
    else if (A_Language == "0809")
    {
      LangSystem := "English_United_Kingdom"
    }
    else if (A_Language == "0c09")
    {
      LangSystem := "English_Australian"
    }
    else if (A_Language == "1009")
    {
      LangSystem := "English_Canadian"
    }
    else if (A_Language == "1409")
    {
      LangSystem := "English_New_Zealand"
    }
    else if (A_Language == "1809")
    {
      LangSystem := "English_Irish"
    }
    else if (A_Language == "1c09")
    {
      LangSystem := "English_South_Africa"
    }
    else if (A_Language == "2009")
    {
      LangSystem := "English_Jamaica"
    }
    else if (A_Language == "2409")
    {
      LangSystem := "English_Caribbean"
    }
    else if (A_Language == "2809")
    {
      LangSystem := "English_Belize"
    }
    else if (A_Language == "2c09")
    {
      LangSystem := "English_Trinidad"
    }
    else if (A_Language == "3009")
    {
      LangSystem := "English_Zimbabwe"
    }
    else if (A_Language == "3409")
    {
      LangSystem := "English_Philippines"
    }
    else if (A_Language == "0425")
    {
      LangSystem := "Estonian"
    }
    else if (A_Language == "0438")
    {
      LangSystem := "Faeroese"
    }
    else if (A_Language == "0429")
    {
      LangSystem := "Farsi"
    }
    else if (A_Language == "040b")
    {
      LangSystem := "Finnish"
    }
    else if (A_Language == "040c")
    {
      LangSystem := "French_Standard"
    }
    else if (A_Language == "080c")
    {
      LangSystem := "French_Belgian"
    }
    else if (A_Language == "0c0c")
    {
      LangSystem := "French_Canadian"
    }
    else if (A_Language == "100c")
    {
      LangSystem := "French_Swiss"
    }
    else if (A_Language == "140c")
    {
      LangSystem := "French_Luxembourg"
    }
    else if (A_Language == "180c")
    {
      LangSystem := "French_Monaco"
    }
    else if (A_Language == "0437")
    {
      LangSystem := "Georgian"
    }
    else if (A_Language == "0407")
    {
      LangSystem := "German_Standard"
    }
    else if (A_Language == "0807")
    {
      LangSystem := "German_Swiss"
    }
    else if (A_Language == "0c07")
    {
      LangSystem := "German_Austrian"
    }
    else if (A_Language == "1007")
    {
      LangSystem := "German_Luxembourg"
    }
    else if (A_Language == "1407")
    {
      LangSystem := "German_Liechtenstein"
    }
    else if (A_Language == "0408")
    {
      LangSystem := "Greek"
    }
    else if (A_Language == "040d")
    {
      LangSystem := "Hebrew"
    }
    else if (A_Language == "0439")
    {
      LangSystem := "Hindi"
    }
    else if (A_Language == "040e")
    {
      LangSystem := "Hungarian"
    }
    else if (A_Language == "040f")
    {
      LangSystem := "Icelandic"
    }
    else if (A_Language == "0421")
    {
      LangSystem := "Indonesian"
    }
    else if (A_Language == "0410")
    {
      LangSystem := "Italian_Standard"
    }
    else if (A_Language == "0810")
    {
      LangSystem := "Italian_Swiss"
    }
    else if (A_Language == "0411")
    {
      LangSystem := "Japanese"
    }
    else if (A_Language == "043f")
    {
      LangSystem := "Kazakh"
    }
    else if (A_Language == "0457")
    {
      LangSystem := "Konkani"
    }
    else if (A_Language == "0412")
    {
      LangSystem := "Korean"
    }
    else if (A_Language == "0426")
    {
      LangSystem := "Latvian"
    }
    else if (A_Language == "0427")
    {
      LangSystem := "Lithuanian"
    }
    else if (A_Language == "042f")
    {
      LangSystem := "Macedonian"
    }
    else if (A_Language == "043e")
    {
      LangSystem := "Malay_Malaysia"
    }
    else if (A_Language == "083e")
    {
      LangSystem := "Malay_Brunei_Darussalam"
    }
    else if (A_Language == "044e")
    {
      LangSystem := "Marathi"
    }
    else if (A_Language == "0414")
    {
      LangSystem := "Norwegian_Bokmal"
    }
    else if (A_Language == "0814")
    {
      LangSystem := "Norwegian_Nynorsk"
    }
    else if (A_Language == "0415")
    {
      LangSystem := "Polish"
    }
    else if (A_Language == "0416")
    {
      LangSystem := "Portuguese_Brazilian"
    }
    else if (A_Language == "0816")
    {
      LangSystem := "Portuguese_Standard"
    }
    else if (A_Language == "0418")
    {
      LangSystem := "Romanian"
    }
    else if (A_Language == "0419")
    {
      LangSystem := "Russian"
    }
    else if (A_Language == "044f")
    {
      LangSystem := "Sanskrit"
    }
    else if (A_Language == "081a")
    {
      LangSystem := "Serbian_Latin"
    }
    else if (A_Language == "0c1a")
    {
      LangSystem := "Serbian_Cyrillic"
    }
    else if (A_Language == "041b")
    {
      LangSystem := "Slovak"
    }
    else if (A_Language == "0424")
    {
      LangSystem := "Slovenian"
    }
    else if (A_Language == "040a")
    {
      LangSystem := "Spanish_Traditional_Sort"
    }
    else if (A_Language == "080a")
    {
      LangSystem := "Spanish_Mexican"
    }
    else if (A_Language == "0c0a")
    {
      LangSystem := "Spanish_Modern_Sort"
    }
    else if (A_Language == "100a")
    {
      LangSystem := "Spanish_Guatemala"
    }
    else if (A_Language == "140a")
    {
      LangSystem := "Spanish_Costa_Rica"
    }
    else if (A_Language == "180a")
    {
      LangSystem := "Spanish_Panama"
    }
    else if (A_Language == "1c0a")
    {
      LangSystem := "Spanish_Dominican_Republic"
    }
    else if (A_Language == "200a")
    {
      LangSystem := "Spanish_Venezuela"
    }
    else if (A_Language == "240a")
    {
      LangSystem := "Spanish_Colombia"
    }
    else if (A_Language == "280a")
    {
      LangSystem := "Spanish_Peru"
    }
    else if (A_Language == "2c0a")
    {
      LangSystem := "Spanish_Argentina"
    }
    else if (A_Language == "300a")
    {
      LangSystem := "Spanish_Ecuador"
    }
    else if (A_Language == "340a")
    {
      LangSystem := "Spanish_Chile"
    }
    else if (A_Language == "380a")
    {
      LangSystem := "Spanish_Uruguay"
    }
    else if (A_Language == "3c0a")
    {
      LangSystem := "Spanish_Paraguay"
    }
    else if (A_Language == "400a")
    {
      LangSystem := "Spanish_Bolivia"
    }
    else if (A_Language == "440a")
    {
      LangSystem := "Spanish_El_Salvador"
    }
    else if (A_Language == "480a")
    {
      LangSystem := "Spanish_Honduras"
    }
    else if (A_Language == "4c0a")
    {
      LangSystem := "Spanish_Nicaragua"
    }
    else if (A_Language == "500a")
    {
      LangSystem := "Spanish_Puerto_Rico"
    }
    else if (A_Language == "0441")
    {
      LangSystem := "Swahili"
    }
    else if (A_Language == "041d")
    {
      LangSystem := "Swedish"
    }
    else if (A_Language == "081d")
    {
      LangSystem := "Swedish_Finland"
    }
    else if (A_Language == "0449")
    {
      LangSystem := "Tamil"
    }
    else if (A_Language == "0444")
    {
      LangSystem := "Tatar"
    }
    else if (A_Language == "041e")
    {
      LangSystem := "Thai"
    }
    else if (A_Language == "041f")
    {
      LangSystem := "Turkish"
    }
    else if (A_Language == "0422")
    {
      LangSystem := "Ukrainian"
    }
    else if (A_Language == "0420")
    {
      LangSystem := "Urdu"
    }
    else if (A_Language == "0443")
    {
      LangSystem := "Uzbek_Latin"
    }
    else if (A_Language == "0843")
    {
      LangSystem := "Uzbek_Cyrillic"
    }
    else if (A_Language == "042a")
    {
      LangSystem := "Vietnamese"
    }
    else
    {
      LangSystem := "UNKNOWN"
    }
    ; -------------------------------------------
  } ; LangSystem
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                    
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; ContactName, ContactEmail
  ; -------------------------------------------
  File_ContactInfo := A_AppData "\PopUpMenu_PUM\system\Contact.txt"
  if FileExist(File_ContactInfo)
  {
    ; -------------------------------------------
    FileReadLine, ContactName, %File_ContactInfo%, 1
    FileReadLine, ContactEmail, %File_ContactInfo%, 2
    ; -------------------------------------------
    DataArray.359.1 := ContactName ; (359_1)(Pum_ContactName [Email Contact Name])
    DataArray.359.2 := ContactEmail ; (359_2)(Pum_ContactEmail [Contact Email Address])
    ; -------------------------------------------
    GuiControl, PopUpMenu:, g_188, %ContactEmail% ; (188_1)(Obj_Pum_EditFeild_EmailAddress)
    GuiControl, PopUpMenu:, g_189, %ContactName% ; (189_1)(Obj_Pum_EditFeild_ContactName)
    ; -------------------------------------------
  }
  else
  {
    ContactName := "Not Entered"
    ContactEmail := "Not Entered"
  }
  ; -------------------------------------------
  ; ContactName, ContactEmail
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  FileDelete, %A_Desktop%\iplocate
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ReturnArray := []
  ReturnArray[1]  := BoardID
  ReturnArray[2]  := SystemName
  ReturnArray[3]  := WindowsVersion
  ReturnArray[4]  := IpPublic
  ReturnArray[5]  := IpPrivate
  ReturnArray[6]  := HasAdminRights
  ReturnArray[7]  := ThisCity
  ReturnArray[8]  := ThisRegion
  ReturnArray[9]  := ThisPostal
  ReturnArray[10] := ThisCountry
  ReturnArray[11] := ThisTimeZone
  ReturnArray[12] := LangPopUpMenu
  ReturnArray[13] := LangSystem
  ReturnArray[14] := ContactName
  ReturnArray[15] := ContactEmail
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; > ReturnArray [(1)BoardID, (2)SystemName, (3)WindowsVersion, (4)IpPublic, (5)IpPrivate, (6)HasAdminRights, (7)ThisCity, (8)ThisRegion, (9)ThisPostal, (10)ThisCountry, (11)ThisTimeZone, (12)LangPopUpMenu, (13)LangSystem, (14)ContactName, (15)ContactEmail]
  ; [(1)BoardID, (2)SystemName, (3)WindowsVersion, (4)IpPublic, (5)IpPrivate, (6)HasAdminRights, (7)ThisCity, (8)ThisRegion, (9)ThisPostal, (10)ThisCountry, (11)ThisTimeZone, (12)LangPopUpMenu, (13)LangSystem, (14)ContactName, (15)ContactEmail]
  return ReturnArray
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  /*
    BoardID         := EmailInfoArray.1
    SystemName      := EmailInfoArray.2
    WindowsVersion  := EmailInfoArray.3
    IpPublic        := EmailInfoArray.4
    IpPrivate       := EmailInfoArray.5
    HasAdminRights  := EmailInfoArray.6
    ThisCity        := EmailInfoArray.7
    ThisRegion      := EmailInfoArray.8
    ThisPostal      := EmailInfoArray.9
    ThisCountry     := EmailInfoArray.10
    ThisTimeZone    := EmailInfoArray.11
    LangPopUpMenu   := EmailInfoArray.12
    LangSystem      := EmailInfoArray.13
    ContactName     := EmailInfoArray.14
    ContactEmail    := EmailInfoArray.15
  */
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}
; -------------------------------------------
Email_Send(Email_Subject, Email_Body, ThisNumber)
{
  ; -------------------------------------------
  HasConnection := Install_ConnectCheck(flag=0x40)
  ; -------------------------------------------
  if (HasConnection == 1)  ; Has Internet Connection an Email_Body is NOT Blank
  {
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Email_Info()
    ; -------------------------------------------
    EmailInfoArray  := Email_Info()
    ; -------------------------------------------
    BoardID         := EmailInfoArray.1
    SystemName      := EmailInfoArray.2
    WindowsVersion  := EmailInfoArray.3
    IpPublic        := EmailInfoArray.4
    IpPrivate       := EmailInfoArray.5
    HasAdminRights  := EmailInfoArray.6
    ThisCity        := EmailInfoArray.7
    ThisRegion      := EmailInfoArray.8
    ThisPostal      := EmailInfoArray.9
    ThisCountry     := EmailInfoArray.10
    ThisTimeZone    := EmailInfoArray.11
    LangPopUpMenu   := EmailInfoArray.12
    LangSystem      := EmailInfoArray.13
    ContactName     := EmailInfoArray.14
    ContactEmail    := EmailInfoArray.15
    ; -------------------------------------------
    ; Email_Info()
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Email_Subject := Email_Subject " (" BoardID ")"
    ; -------------------------------------------
    EmailFolder := A_AppData "\PopUpMenu_PUM\emailtemp"
    if !FileExist(EmailFolder)
    {
      FileCreateDir, %EmailFolder%
      Sleep, 10
    }
    ; -------------------------------------------
    PumMailSend  := A_AppData "\PopUpMenu_PUM\emailtemp\PopUpMenu_MailSend.exe"
    ; -------------------------------------------
    ; (PopUpMenu_MailSend.exe) Will Not Work in in (C:\Program Files)
    ; (_07-Apr-2022_14-47-56_)
    ; -------------------------------------------
    if !FileExist(PumMailSend)
    {
      SupportPumMailSend := A_ProgramFiles "\PopUpMenu_PUM\support\PopUpMenu_MailSend.exe"
      FileCopy, %SupportPumMailSend%, %EmailFolder%, 1
      Sleep, 10
    }
    ; -------------------------------------------
    EmailFile := A_AppData "\PopUpMenu_PUM\emailtemp\EmailFile.bat"
    EmailFileLnk := A_AppData "\PopUpMenu_PUM\emailtemp\EmailFile.lnk"
    ; -------------------------------------------
    EmailTempFolder := A_AppData "\PopUpMenu_PUM\emailtemp"
    if !FileExist(EmailTempFolder)
    {
      FileCreateDir, %EmailTempFolder%
      Sleep, 10
    }
    ; -------------------------------------------
    Email_To       := "popupmenu.system@gmail.com"
    ; -------------------------------------------
    Email_From     := "popupmenu@yahoo.com"
    ; -------------------------------------------
    ; Old Password
    ; Email_PassWord := """yhanndksgpskbzps"""
    ; -------------------------------------------
    ; New Password (_21_Mar_2024_)(_15_27_39_)
    Email_PassWord := """aqvicmdykuaisioc"""
    ; -------------------------------------------
    Email_Subject  := """" Email_Subject """"
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    if (InStr(Email_Subject, "EmailKeepActive") == 0)
    {
      ; -------------------------------------------
      Line_1  := "**************************************"
      Line_2  := "BoardID        " BoardID
      Line_3  := "----------------------------------"
      Line_4  := "Installer        " ThisNumber
		  Line_5  := "----------------------------------"
		  Line_6  := "Entered_Name"           A_Tab A_Tab      ContactName
		  Line_7  := "Entered_Email"          A_Tab A_Tab      ContactEmail
		  Line_8  := "----------------------------------"
		  Line_9  := "System_User_Name"       A_Tab A_Tab      A_UserName
		  Line_10 := "Has_Admin_Rights"       A_Tab A_Tab      HasAdminRights
		  Line_11 := "PopUpMenu_Lang"         A_Tab A_Tab      LangPopUpMenu
		  Line_12 := "System_Lang"           A_Tab A_Tab      LangSystem
		  Line_13 := "----------------------------------"
		  Line_14 := "AutoHotKey_Version"   A_Tab A_Tab       A_AhkVersion
		  Line_15 := "Windows_Version"       A_Tab A_Tab       WindowsVersion
		  Line_16 := "System_Name"           A_Tab A_Tab       SystemName
		  Line_17 := "Screen_DPI"            A_Tab A_Tab       A_ScreenDPI
		  Line_18 := "Screen_Width"          A_Tab A_Tab       A_ScreenWidth
		  Line_19 := "Screen_Height"         A_Tab A_Tab       A_ScreenHeight
		  Line_20 := "----------------------------------"
		  Line_21 := "Public_IP"             A_Tab A_Tab       IpPublic
		  Line_22 := "Private_IP"            A_Tab A_Tab       IpPrivate
		  Line_23 := "Time_Zone"             A_Tab A_Tab       ThisTimeZone
		  Line_24 := "City"                  A_Tab A_Tab       ThisCity
		  Line_25 := "Region"                A_Tab A_Tab       ThisRegion
		  Line_26 := "Postal_Code"           A_Tab A_Tab       ThisPostal
		  Line_27 := "Country"               A_Tab A_Tab       ThisCountry
      Line_28 := "**************************************"
      ; -------------------------------------------
      ThisNum := 0
      Email_Array := ""
      Loop 27
      {
        ThisNum := ThisNum + 1
        ThisLine := Line_%ThisNum%
        Email_Array := EmailSendArrayAdd(Email_Array, ThisLine, "End") ; ThisArray, AddThis, ThisPos > ThisArray
      }
      ; -------------------------------------------
      Email_Body := StrReplace(Email_Body, "`n", "***Return***<<<Return>>>")
      Body_Array := StrSplit(Email_Body, "***Return***")
      for Index, ThisLine in Body_Array
      {
        if (InStr(ThisLine, "<<<Return>>>") > 0)
        {
          ThisLine := StrReplace(ThisLine, "<<<Return>>>", "   ")
        }
        Email_Array := EmailSendArrayAdd(Email_Array, ThisLine, "End") ; ThisArray, AddThis, ThisPos > ThisArray
      }
      ; -------------------------------------------
      WriteBody := ""
      for Index, ThisLine in Email_Array
      {
        WriteBody := WriteBody " -M """ ThisLine """"
      }
      ; -------------------------------------------
    } ; if (InStr(Email_Subject, "EmailKeepActive") == 0)
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    WriteLine := PumMailSend " -to " Email_To " -from " Email_From " -ssl -port 465 -auth -smtp smtp.mail.yahoo.com -sub test +cc +bc -v -user popupmenu -pass " Email_PassWord " -subject " Email_Subject WriteBody
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    FileDelete, %EmailFile%
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    FileEncoding, UTF-8
    FileAppend, `n, %EmailFile% ; UTF-8
    FileAppend, `n, %EmailFile% ; UTF-8
    FileAppend, %WriteLine%`n, %EmailFile% ; UTF-8
    Sleep, 250
    ; -------------------------------------------    
    ;
    ; -------------------------------------------
    FileCreateShortcut, %EmailFile%, %EmailFileLnk%
    Sleep, 500
    Run %EmailFileLnk% , , Hide
    Sleep, 500
    ; -------------------------------------------
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Wait until Process is NOT Running
    ; -------------------------------------------
    ThisProcess := "EmailFile.bat"
    Process, Exist, %ThisProcess%
    ; -------------------------------------------
    while (ErrorLevel != 0) ; Process Exist
    {
      ; -------------------------------------------
      Sleep, 500
      ; -------------------------------------------
      Process, Exist, %ThisProcess%
      ; -------------------------------------------
    } ; [End] while (ErrorLevel == 0)
    ; -------------------------------------------
    ; Wait until Process is NOT Running
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Delete Old Files
    ; -------------------------------------------
    FileDelete, %EmailFile%
    FileDelete, %EmailFileLnk%
    ; -------------------------------------------
    ; Delete Old Files
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  } ; [End] if (HasConnection == 1)  ; Has Internet Connection
  ; -------------------------------------------
} ; [End] Email_Send(Email_Subject, Email_Body)
; -------------------------------------------
EmailInfoHasAdminRights()
{
  ; -------------------------------------------
  TOKEN_QUERY := 0x0008
  TokenElevationTypeDefault := 1
  TokenElevationTypeFull := 2
  TokenElevationTypeLimited := 3
  TokenType := 8
  TokenElevationType := 18
  ; -------------------------------------------
  TokenInformationClass := TokenElevationType
  DllCall("SetLastError", "UInt", 0)
  ret := DllCall("Advapi32.dll\OpenProcessToken", "UInt", DllCall("GetCurrentProcess"), "UInt", TOKEN_QUERY, "UIntP", hToken)
  ; -------------------------------------------
  DllCall("SetLastError", "UInt", 0)
  DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", TokenInformationClass, "Int", 0, "Int", 0, "UIntP", ReturnLength)
  ; -------------------------------------------
  sizeof_elevationType:=VarSetCapacity(elevationType, ReturnLength, 0)
  DllCall("SetLastError", "UInt", 0)
  DllCall("Advapi32.dll\GetTokenInformation", "UInt", hToken, "UInt", TokenInformationClass, "UIntP", elevationType, "Int", sizeof_elevationType, "UIntP", ReturnLength)
  ; -------------------------------------------
  if (elevationType=TokenElevationTypeDefault)
  {
    ThisUserHasAdminRights := 0
  }
  else if (elevationType=TokenElevationTypeFull)
  {
    ThisUserHasAdminRights := 1
  }
  else if (elevationType=TokenElevationTypeLimited)
  {
    ThisUserHasAdminRights := 1
  }
  else
  {
    ThisUserHasAdminRights := 0
  }
  if (hToken)
  {
    DllCall("CloseHandle", "UInt", hToken)
  }
  ; -------------------------------------------
  return ThisUserHasAdminRights
  ; -------------------------------------------
} ; [End] CheckHasAdminRights()
; -------------------------------------------
EmailSendArrayAdd(ThisArray, AddThis, ThisPos) ; ThisArray, AddThis, ThisPos > ThisArray
{
  ; -------------------------------------------
  if !ThisPos
  {
    ThisPos := "End"
  }
  ; -------------------------------------------
  if AddThis
  {
    CheckThis := ThisArray[1]
    if CheckThis
    {
      if (ThisPos == "End")
      {
        ThisArray.Push(AddThis) ; Adds (AddThis) to End
      }
      else
      {
        if (ThisPos == 0)
        {
          ThisPos := 1
        }
        ThisArray.InsertAt(ThisPos, AddThis) ; Adds (AddThis) at (ThisPos)
      }
    } ; End if CheckThis
    else
    {
      ThisArray := []
      ThisArray[1] := AddThis
    } ; End else
  } ; End if AddThis
  return ThisArray
}
; -------------------------------------------
ErrorGUI(UserLang, ErrorNum, InstallerNumber, ThisType, ThisApp, ThisLang) ; ErrorGUI(ThisLang, ["E1-E6/"EX"/"Text"], InstallerNumber, ["Program"/"Plugin"], ThisApp, ThisLang)
{
  ; -------------------------------------------
  if (ThisLang == "")
  {
    ThisLang := UserLang
  }
  ; -------------------------------------------
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Gui Message
  ; -------------------------------------------
  if (ErrorNum == "EX")
  {
    ; -------------------------------------------
    SetTimer, Label_CountDown, Off ; (CountDown)
    ; -------------------------------------------
    GuiControl, , Var_Message, %Image_Error_EX%
    GuiControl, Show, Var_Message
    ; -------------------------------------------
    Sleep, 3000 ; Sleep, 3 Sceonds to Let Any Download Finish
    ; -------------------------------------------
    if (ThisType == "Program")
    {
      CancelInstall("EX", "Program", "", "") ; CancelInstall(["E1-E6","EX"], ["Program","Plugin"], ThisApp, ThisLang) ; > ExitApp
    }
    else if (ThisType == "Plugin")
    {
      CancelInstall("EX", "Plugin", ThisApp, ThisLang) ; CancelInstall(["E1-E6","EX"], ["Program","Plugin"], ThisApp, ThisLang) ; > ExitApp
    }
    ; -------------------------------------------
  }
  else if (ErrorNum == "E1" or ErrorNum == "E2" or ErrorNum == "E3" or ErrorNum == "E4" or ErrorNum == "E5" or ErrorNum == "E6")
  {
    if (ErrorNum == "E1")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E1_%ThisLang%.png ; (E1 Install Failed)
    }
    else if (ErrorNum == "E2")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E2_%ThisLang%.png ; [ERROR] (E2 Already Installed)
    }
    else if (ErrorNum == "E3")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E3_%ThisLang%.png ; (E3 No Internet Connection)
    }
    else if (ErrorNum == "E4")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E4_%ThisLang%.png ; (E4 No Admin Rights)
    }
    else if (ErrorNum == "E5")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E5_%ThisLang%.png ; (E5)(Download Failed)
    }
    else if (ErrorNum == "E6")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E6_%ThisLang%.png ; (E6 Installer Expired)
    }
    else if (ErrorNum == "E7")
    {
      GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_E7_%ThisLang%.png ; (E7)(PopUpMenu Not Installed)
    }
    ; -------------------------------------------
    GuiControl, Show, Var_Message
    ; -------------------------------------------
    SetTimer, Label_CountDown, 750 ; (CountDown)
    ; -------------------------------------------
  }
  ; -------------------------------------------
  ; Gui Message
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Send Email About Error
  ; -------------------------------------------
  Email_Subject := "(Installer Error " InstallerNumber ")"
  Email_Body := ""
  ; -------------------------------------------
  if (ThisType == "Program")
  {
    Email_Body := Email_Body "Program Install`n"
  }
  else if (ThisType == "Plugin")
  {
    Email_Body := Email_Body "Plugin Install`n"
    Email_Body := Email_Body ThisApp "_" ThisLang "`n"
  }
  Email_Body := Email_Body "`n"
  Email_Body := Email_Body "UserLang = " UserLang "`n"
  Email_Body := Email_Body "`n"
  Email_Body := Email_Body "InstallerNumber = " InstallerNumber "`n"
  Email_Body := Email_Body "`n"
  ;
  ; -------------------------------------------
  if (ErrorNum == "E1")
  {
    Email_Body := Email_Body "Error Message = (E1)(Install Failed)`n"
  }
  else if (ErrorNum == "E2")
  {
    Email_Body := Email_Body "Error Message = (E2)(Already Installed)`n"
  }
  else if (ErrorNum == "E4")
  {
    Email_Body := Email_Body "Error Message = (E4)(No Admin Rights)`n"
  }
  else if (ErrorNum == "E5")
  {
    Email_Body := Email_Body "Error Message = (E5)(Download Failed)`n"
  }
  else if (ErrorNum == "E6")
  {
    Email_Body := Email_Body "Error Message = (E6)(Installer Expired)`n"
  }
  else if (ErrorNum == "E7")
  {
    Email_Body := Email_Body "Error Message = (E7)(PopUpMenu Not Installed)`n"
  }
  else if (ErrorNum == "EX")
  {
    Email_Body := Email_Body "(EX)(User Canceled Install)`n"
  }
  else
  {
    Email_Body := Email_Body ErrorNum
  }
  ; -------------------------------------------
  Email_Send(Email_Subject, Email_Body, InstallerNumber)
  ; -------------------------------------------
  ; Send Email About Error
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; -------------------------------------------
  return ErrorNum
  ; -------------------------------------------
} ; [End] ErrorGUI(ThisLang, ErrorNum, InstallerNumber, ThisType, ThisApp, ThisLang)
; -------------------------------------------
File_UnZip(ZipFile, UnZipDir) ; (ZipFile, UnZipDir)
{
  ; -------------------------------------------
  if !FileExist(UnZipDir)
  {
    FileCreateDir, %UnZipDir%
  }
  ; -------------------------------------------
  psh := ComObjCreate("Shell.Application")
  psh.Namespace( UnZipDir ).CopyHere( psh.Namespace( ZipFile ).items, 4|16 )
  ; -------------------------------------------
} ; [End] File_UnZip(ZipFile, UnZipDir)
; -------------------------------------------
FinishRun()
{
  ; -------------------------------------------
  ; Install Finished (Run) PopUpMenu
  ; -------------------------------------------
  LinkS_PopUpMenu := A_Desktop "\PopUpMenu.lnk"
  Program_PopUpMenu := A_Programfiles "\PopUpMenu_PUM\PopUpMenu.ahk"
  ; -------------------------------------------
  if FileExist(LinkS_PopUpMenu)
  {
    ; -------------------------------------------
    Run, %LinkS_PopUpMenu%
    ; -------------------------------------------
  }
  else if FileExist(Program_PopUpMenu)
  {
    ; -------------------------------------------
    Run, %Program_PopUpMenu%
    ; -------------------------------------------
  }
  ; -------------------------------------------
  Sleep, 500
  ; -------------------------------------------
  BreakTime := A_TickCount + 2000
  while !WinExist("PopUpMenu.ahk" . " ahk_class AutoHotkey")
  {
    if (BreakTime > A_TickCount)
    {
      break
    }
  }
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  DeleteThisDir := A_Temp "\PopUpMenu"
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ; -------------------------------------------
  BreakTime := A_TickCount + 10000 ; 10 Seconds
  while FileExist(DeleteThisDir)
  {
    if (BreakTime > A_TickCount)
    {
      break
    }
  }
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  ExitApp ; "Finish"
  ; -------------------------------------------
} ; [End] FinishRun()
; -------------------------------------------
GetIP(URL)
{
	; -------------------------------------------
  http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
  http.Open("GET",URL,1)
  http.Send()
	; -------------------------------------------
  http.WaitForResponse
  If (http.ResponseText="Error")
	{
		ReturnThis := "NoIP"
    return ReturnThis
  }
  return http.ResponseText
	; -------------------------------------------
}
; -------------------------------------------
GetLangInstall() ; > UserLang
{
  ; -------------------------------------------
  if (A_Language == "0407" or A_Language == "0807" or A_Language == "0c07" or A_Language == "1007" or A_Language == "1407")
  {
    ; -------------------------------------------
    UserLang := "de"
    ; -------------------------------------------
  } ; [End] German (de)
  ; -------------------------------------------
  else if (A_Language == "0409" or A_Language == "0809" or A_Language == "0c09" or A_Language == "1009" or A_Language == "1409" or A_Language == "1809" or A_Language == "1c09" or A_Language == "2009" or A_Language == "2409" or A_Language == "2809" or A_Language == "2c09" or A_Language == "3009" or A_Language == "3409")
  {
    ; -------------------------------------------
    UserLang := "en"
    ; -------------------------------------------
  } ; [End] English (en)
  ; -------------------------------------------
  else if (A_Language == "040a" or A_Language == "080a" or A_Language == "0c0a" or A_Language == "100a" or A_Language == "140a" or A_Language == "180a" or A_Language == "1c0a" or A_Language == "200a" or A_Language == "240a" or A_Language == "280a" or A_Language == "2c0a" or A_Language == "300a" or A_Language == "340a" or A_Language == "380a" or A_Language == "3c0a" or A_Language == "400a" or A_Language == "440a" or A_Language == "480a" or A_Language == "4c0a" or A_Language == "500a")
  {
    ; -------------------------------------------
    UserLang := "es"
    ; -------------------------------------------
  } ; [End] Spanish (es)
  ; -------------------------------------------
  else if (A_Language == "040c" or A_Language == "080c" or A_Language == "0c0c" or A_Language == "100c" or A_Language == "140c" or A_Language == "180c")
  {
    ; -------------------------------------------
    UserLang := "fr"
    ; -------------------------------------------
  } ; [End] French (fr)
  ; -------------------------------------------
  else if (A_Language == "0410" or A_Language == "0810")
  {
    ; -------------------------------------------
    UserLang := "it"
    ; -------------------------------------------
  } ; [End] Italian (it)
  ; -------------------------------------------
  else if (A_Language == "0415")
  {
    ; -------------------------------------------
    UserLang := "pl"
    ; -------------------------------------------
  } ; [End] Polish (pl)
  ; -------------------------------------------
  else if (A_Language == "0416" or A_Language == "0816")
  {
    ; -------------------------------------------
    UserLang := "pt"
    ; -------------------------------------------
  } ; [End] Portuguese (pt)
  ; -------------------------------------------
  else if (A_Language == "0419")
  {
    ; -------------------------------------------
    UserLang := "ru"
    ; -------------------------------------------
  } ; [End] Russian (ru)
  ; -------------------------------------------
  else if (A_Language == "041d" or A_Language == "081d")
  {
    ; -------------------------------------------
    UserLang := "sv"
    ; -------------------------------------------
  } ; [End] Swedish (sv)
  ; -------------------------------------------
  else if (A_Language == "041f")
  {
    ; -------------------------------------------
    UserLang := "tr"
    ; -------------------------------------------
  } ; [End] Turkish (tr)
  ; -------------------------------------------
  else ; English (en)
  {
    ; -------------------------------------------
    UserLang := "en"
    ; -------------------------------------------
  } ; [End] else ; English (en)
  ; -------------------------------------------
  return UserLang
  ; -------------------------------------------
} ; [End] GetLang () ; > UserLang
; -------------------------------------------
GetLangSystem() ; > LangSystem := "Afrikaans"
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; LangSystem
  ; -------------------------------------------
  if (A_Language == "0436")
  {
    LangSystem := "Afrikaans"
  }
  else if (A_Language == "041c")
  {
    LangSystem := "Albanian"
  }
  else if (A_Language == "0401")
  {
    LangSystem := "Arabic_Saudi_Arabia"
  }
  else if (A_Language == "0801")
  {
    LangSystem := "Arabic_Iraq"
  }
  else if (A_Language == "0c01")
  {
    LangSystem := "Arabic_Egypt"
  }
  else if (A_Language == "1001")
  {
    LangSystem := "Arabic_Libya"
  }
  else if (A_Language == "1401")
  {
    LangSystem := "Arabic_Algeria"
  }
  else if (A_Language == "1801")
  {
    LangSystem := "Arabic_Morocco"
  }
  else if (A_Language == "1c01")
  {
    LangSystem := "Arabic_Tunisia"
  }
  else if (A_Language == "2001")
  {
    LangSystem := "Arabic_Oman"
  }
  else if (A_Language == "2401")
  {
    LangSystem := "Arabic_Yemen"
  }
  else if (A_Language == "2801")
  {
    LangSystem := "Arabic_Syria"
  }
  else if (A_Language == "2c01")
  {
    LangSystem := "Arabic_Jordan"
  }
  else if (A_Language == "3001")
  {
    LangSystem := "Arabic_Lebanon"
  }
  else if (A_Language == "3401")
  {
    LangSystem := "Arabic_Kuwait"
  }
  else if (A_Language == "3801")
  {
    LangSystem := "Arabic_UAE"
  }
  else if (A_Language == "3c01")
  {
    LangSystem := "Arabic_Bahrain"
  }
  else if (A_Language == "4001")
  {
    LangSystem := "Arabic_Qatar"
  }
  else if (A_Language == "042b")
  {
    LangSystem := "Armenian"
  }
  else if (A_Language == "042c")
  {
    LangSystem := "Azeri_Latin"
  }
  else if (A_Language == "082c")
  {
    LangSystem := "Azeri_Cyrillic"
  }
  else if (A_Language == "042d")
  {
    LangSystem := "Basque"
  }
  else if (A_Language == "0423")
  {
    LangSystem := "Belarusian"
  }
  else if (A_Language == "0402")
  {
    LangSystem := "Bulgarian"
  }
  else if (A_Language == "0403")
  {
    LangSystem := "Catalan"
  }
  else if (A_Language == "0404")
  {
    LangSystem := "Chinese_Taiwan"
  }
  else if (A_Language == "0804")
  {
    LangSystem := "Chinese_PRC"
  }
  else if (A_Language == "0c04")
  {
    LangSystem := "Chinese_Hong_Kong"
  }
  else if (A_Language == "1004")
  {
    LangSystem := "Chinese_Singapore"
  }
  else if (A_Language == "1404")
  {
    LangSystem := "Chinese_Macau"
  }
  else if (A_Language == "041a")
  {
    LangSystem := "Croatian"
  }
  else if (A_Language == "0405")
  {
    LangSystem := "Czech"
  }
  else if (A_Language == "0406")
  {
    LangSystem := "Danish"
  }
  else if (A_Language == "0413")
  {
    LangSystem := "Dutch_Standard"
  }
  else if (A_Language == "0813")
  {
    LangSystem := "Dutch_Belgian"
  }
  else if (A_Language == "0409")
  {
    LangSystem := "English_United_States"
  }
  else if (A_Language == "0809")
  {
    LangSystem := "English_United_Kingdom"
  }
  else if (A_Language == "0c09")
  {
    LangSystem := "English_Australian"
  }
  else if (A_Language == "1009")
  {
    LangSystem := "English_Canadian"
  }
  else if (A_Language == "1409")
  {
    LangSystem := "English_New_Zealand"
  }
  else if (A_Language == "1809")
  {
    LangSystem := "English_Irish"
  }
  else if (A_Language == "1c09")
  {
    LangSystem := "English_South_Africa"
  }
  else if (A_Language == "2009")
  {
    LangSystem := "English_Jamaica"
  }
  else if (A_Language == "2409")
  {
    LangSystem := "English_Caribbean"
  }
  else if (A_Language == "2809")
  {
    LangSystem := "English_Belize"
  }
  else if (A_Language == "2c09")
  {
    LangSystem := "English_Trinidad"
  }
  else if (A_Language == "3009")
  {
    LangSystem := "English_Zimbabwe"
  }
  else if (A_Language == "3409")
  {
    LangSystem := "English_Philippines"
  }
  else if (A_Language == "0425")
  {
    LangSystem := "Estonian"
  }
  else if (A_Language == "0438")
  {
    LangSystem := "Faeroese"
  }
  else if (A_Language == "0429")
  {
    LangSystem := "Farsi"
  }
  else if (A_Language == "040b")
  {
    LangSystem := "Finnish"
  }
  else if (A_Language == "040c")
  {
    LangSystem := "French_Standard"
  }
  else if (A_Language == "080c")
  {
    LangSystem := "French_Belgian"
  }
  else if (A_Language == "0c0c")
  {
    LangSystem := "French_Canadian"
  }
  else if (A_Language == "100c")
  {
    LangSystem := "French_Swiss"
  }
  else if (A_Language == "140c")
  {
    LangSystem := "French_Luxembourg"
  }
  else if (A_Language == "180c")
  {
    LangSystem := "French_Monaco"
  }
  else if (A_Language == "0437")
  {
    LangSystem := "Georgian"
  }
  else if (A_Language == "0407")
  {
    LangSystem := "German_Standard"
  }
  else if (A_Language == "0807")
  {
    LangSystem := "German_Swiss"
  }
  else if (A_Language == "0c07")
  {
    LangSystem := "German_Austrian"
  }
  else if (A_Language == "1007")
  {
    LangSystem := "German_Luxembourg"
  }
  else if (A_Language == "1407")
  {
    LangSystem := "German_Liechtenstein"
  }
  else if (A_Language == "0408")
  {
    LangSystem := "Greek"
  }
  else if (A_Language == "040d")
  {
    LangSystem := "Hebrew"
  }
  else if (A_Language == "0439")
  {
    LangSystem := "Hindi"
  }
  else if (A_Language == "040e")
  {
    LangSystem := "Hungarian"
  }
  else if (A_Language == "040f")
  {
    LangSystem := "Icelandic"
  }
  else if (A_Language == "0421")
  {
    LangSystem := "Indonesian"
  }
  else if (A_Language == "0410")
  {
    LangSystem := "Italian_Standard"
  }
  else if (A_Language == "0810")
  {
    LangSystem := "Italian_Swiss"
  }
  else if (A_Language == "0411")
  {
    LangSystem := "Japanese"
  }
  else if (A_Language == "043f")
  {
    LangSystem := "Kazakh"
  }
  else if (A_Language == "0457")
  {
    LangSystem := "Konkani"
  }
  else if (A_Language == "0412")
  {
    LangSystem := "Korean"
  }
  else if (A_Language == "0426")
  {
    LangSystem := "Latvian"
  }
  else if (A_Language == "0427")
  {
    LangSystem := "Lithuanian"
  }
  else if (A_Language == "042f")
  {
    LangSystem := "Macedonian"
  }
  else if (A_Language == "043e")
  {
    LangSystem := "Malay_Malaysia"
  }
  else if (A_Language == "083e")
  {
    LangSystem := "Malay_Brunei_Darussalam"
  }
  else if (A_Language == "044e")
  {
    LangSystem := "Marathi"
  }
  else if (A_Language == "0414")
  {
    LangSystem := "Norwegian_Bokmal"
  }
  else if (A_Language == "0814")
  {
    LangSystem := "Norwegian_Nynorsk"
  }
  else if (A_Language == "0415")
  {
    LangSystem := "Polish"
  }
  else if (A_Language == "0416")
  {
    LangSystem := "Portuguese_Brazilian"
  }
  else if (A_Language == "0816")
  {
    LangSystem := "Portuguese_Standard"
  }
  else if (A_Language == "0418")
  {
    LangSystem := "Romanian"
  }
  else if (A_Language == "0419")
  {
    LangSystem := "Russian"
  }
  else if (A_Language == "044f")
  {
    LangSystem := "Sanskrit"
  }
  else if (A_Language == "081a")
  {
    LangSystem := "Serbian_Latin"
  }
  else if (A_Language == "0c1a")
  {
    LangSystem := "Serbian_Cyrillic"
  }
  else if (A_Language == "041b")
  {
    LangSystem := "Slovak"
  }
  else if (A_Language == "0424")
  {
    LangSystem := "Slovenian"
  }
  else if (A_Language == "040a")
  {
    LangSystem := "Spanish_Traditional_Sort"
  }
  else if (A_Language == "080a")
  {
    LangSystem := "Spanish_Mexican"
  }
  else if (A_Language == "0c0a")
  {
    LangSystem := "Spanish_Modern_Sort"
  }
  else if (A_Language == "100a")
  {
    LangSystem := "Spanish_Guatemala"
  }
  else if (A_Language == "140a")
  {
    LangSystem := "Spanish_Costa_Rica"
  }
  else if (A_Language == "180a")
  {
    LangSystem := "Spanish_Panama"
  }
  else if (A_Language == "1c0a")
  {
    LangSystem := "Spanish_Dominican_Republic"
  }
  else if (A_Language == "200a")
  {
    LangSystem := "Spanish_Venezuela"
  }
  else if (A_Language == "240a")
  {
    LangSystem := "Spanish_Colombia"
  }
  else if (A_Language == "280a")
  {
    LangSystem := "Spanish_Peru"
  }
  else if (A_Language == "2c0a")
  {
    LangSystem := "Spanish_Argentina"
  }
  else if (A_Language == "300a")
  {
    LangSystem := "Spanish_Ecuador"
  }
  else if (A_Language == "340a")
  {
    LangSystem := "Spanish_Chile"
  }
  else if (A_Language == "380a")
  {
    LangSystem := "Spanish_Uruguay"
  }
  else if (A_Language == "3c0a")
  {
    LangSystem := "Spanish_Paraguay"
  }
  else if (A_Language == "400a")
  {
    LangSystem := "Spanish_Bolivia"
  }
  else if (A_Language == "440a")
  {
    LangSystem := "Spanish_El_Salvador"
  }
  else if (A_Language == "480a")
  {
    LangSystem := "Spanish_Honduras"
  }
  else if (A_Language == "4c0a")
  {
    LangSystem := "Spanish_Nicaragua"
  }
  else if (A_Language == "500a")
  {
    LangSystem := "Spanish_Puerto_Rico"
  }
  else if (A_Language == "0441")
  {
    LangSystem := "Swahili"
  }
  else if (A_Language == "041d")
  {
    LangSystem := "Swedish"
  }
  else if (A_Language == "081d")
  {
    LangSystem := "Swedish_Finland"
  }
  else if (A_Language == "0449")
  {
    LangSystem := "Tamil"
  }
  else if (A_Language == "0444")
  {
    LangSystem := "Tatar"
  }
  else if (A_Language == "041e")
  {
    LangSystem := "Thai"
  }
  else if (A_Language == "041f")
  {
    LangSystem := "Turkish"
  }
  else if (A_Language == "0422")
  {
    LangSystem := "Ukrainian"
  }
  else if (A_Language == "0420")
  {
    LangSystem := "Urdu"
  }
  else if (A_Language == "0443")
  {
    LangSystem := "Uzbek_Latin"
  }
  else if (A_Language == "0843")
  {
    LangSystem := "Uzbek_Cyrillic"
  }
  else if (A_Language == "042a")
  {
    LangSystem := "Vietnamese"
  }
  else
  {
    LangSystem := "UNKNOWN"
  }
  ; -------------------------------------------
  return LangSystem
  ; -------------------------------------------
} ; [End] GetLangSystem() ; > LangSystem := "Afrikaans"
; -------------------------------------------
GetLocation() ; ReturnArray := ["IP", "TimeZone", "Region", "City", "ZipCode", "Country"]
{
  ; -------------------------------------------
  File_IpLocatorBat := A_AppData "\PopUpMenu_PUM\emailtemp\IpLocator.bat"
  File_IpLocatorLnk := A_AppData "\PopUpMenu_PUM\emailtemp\IpLocator.lnk"
  File_TimeZone := Folder_EmailTemp "\TimeZone.txt"
  File_Region   := Folder_EmailTemp "\Region.txt"
  File_City     := Folder_EmailTemp "\City.txt"
  File_ZipCode  := Folder_EmailTemp "\ZipCode.txt"
  File_Country  := Folder_EmailTemp "\Country.txt"
  ; -------------------------------------------
  FileDelete, %File_IpLocatorBat%
  FileDelete, %File_IpLocatorLnk%
  FileDelete, %File_TimeZone%
  FileDelete, %File_Region%
  FileDelete, %File_City%
  FileDelete, %File_ZipCode%
  FileDelete, %File_Country%
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  ThisIP := GetIP("http://www.netikus.net/show_ip.html")
  ; -------------------------------------------
  if (ThisIP == "NoIP")
	{
		; -------------------------------------------
    FileDelete, %File_IpLocatorBat%
    FileDelete, %File_IpLocatorLnk%
    FileDelete, %File_TimeZone%
    FileDelete, %File_Region%
    FileDelete, %File_City%
    FileDelete, %File_ZipCode%
    FileDelete, %File_Country%
    ; -------------------------------------------
		ReturnArray := ["IP Unknown", "TimeZone Unknown", "Region Unknown", "City Unknown", "ZipCode Unknown", "Country Unknown"]
		; -------------------------------------------
	}
	else
  {
    ; -------------------------------------------
    Line_1 := "curl ipinfo.io/" ThisIP "/timezone > " File_TimeZone "`n"
    Line_2 := "curl ipinfo.io/" ThisIP "/region > " File_Region "`n"
    Line_3 := "curl ipinfo.io/" ThisIP "/city > " File_City "`n"
    Line_4 := "curl ipinfo.io/" ThisIP "/postal > " File_ZipCode "`n"
    Line_5 := "curl ipinfo.io/" ThisIP "/country > " File_Country "`n"
  	; -------------------------------------------
    FileEncoding, UTF-8
  	FileAppend, %Line_1%, %File_IpLocatorBat%
  	FileAppend, %Line_2%, %File_IpLocatorBat%
  	FileAppend, %Line_3%, %File_IpLocatorBat%
  	FileAppend, %Line_4%, %File_IpLocatorBat%
  	FileAppend, %Line_5%, %File_IpLocatorBat%
  	; -------------------------------------------
    FileCreateShortcut, %File_IpLocatorBat%, %File_IpLocatorLnk%
    ; -------------------------------------------
    RunWait %File_IpLocatorLnk% , , Hide
  	; -------------------------------------------
  	FileDelete, %File_IpLocatorBat%
    FileDelete, %File_IpLocatorLnk%
  	; -------------------------------------------
    FileEncoding, UTF-8
		FileReadLine, ThisTimeZone, %File_TimeZone%, 1
		FileReadLine, ThisRegion, %File_Region%, 1
		FileReadLine, ThisCity, %File_City%, 1
		FileReadLine, ThisZipCode, %File_ZipCode%, 1
		FileReadLine, ThisCountry, %File_Country%, 1
		; -------------------------------------------
    FileDelete, %File_IpLocatorBat%
    FileDelete, %File_IpLocatorLnk%
    FileDelete, %File_TimeZone%
    FileDelete, %File_Region%
    FileDelete, %File_City%
    FileDelete, %File_ZipCode%
    FileDelete, %File_Country%
    ; -------------------------------------------
		ReturnArray := [ThisIP, ThisTimeZone, ThisRegion, ThisCity, ThisZipCode, ThisCountry]
		; -------------------------------------------
  }
	; -------------------------------------------
	;
	; -------------------------------------------
	return ReturnArray
	; -------------------------------------------
}
; -------------------------------------------
GetPercent(GetPercentArray) ; > ThisPercent
{
  ; -------------------------------------------
  ; (ThisType == "File")   [ThisType, ThisFile, ThisTotal]
  ; (ThisType == "Number") [ThisType, [[FileSize, FilePath], [FileSize, FilePath], etc], ThisTotal]
  ; -------------------------------------------
  ThisType := GetPercentArray.1
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  if (ThisType == "File")
  {
    ; -------------------------------------------
    ThisFile := GetPercentArray.2
    ThisTotal := GetPercentArray.3
    ; -------------------------------------------
    if FileExist(ThisFile)
    {
      FileGetSize, SizeNow, %ThisFile%
    }
    else
    {
      SizeNow := 0
    }
  }
  ; -------------------------------------------
  else if (ThisType == "Number")
  {
    ; -------------------------------------------
    ThisArray := GetPercentArray.2
    ThisTotal := GetPercentArray.3
    ; -------------------------------------------
    SizeNow := ThisTotal
    ; -------------------------------------------
    for index, ThisArray in ArraySize
    {
      ; -------------------------------------------
      ThisSize := ThisArray.1
      ThisFile := ThisArray.2
      ; -------------------------------------------
      if FileExist(ThisFile)
      {
        ; -------------------------------------------
        SizeNow := SizeNow - ThisSize
        ; -------------------------------------------
      } ; [End] if FileExist(ThisFile)
    } ; [End] for index, ThisArray in ArraySize
    ; -------------------------------------------
  } ; [End] else if (ThisType == "Number")
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  ThisPercent := (SizeNow / SizeTotal) * 100
  ; -------------------------------------------
  return ThisPercent
  ; -------------------------------------------
} ; [End] GetPercent(GetPercentArray) ; > ThisPercent
; -------------------------------------------
GetPercentArray(FileArray, TotalSize) ; GetPercentArray(FileArray, TotalSize) > ThisPercent
{
  ; -------------------------------------------
  TotalNow := 0
  ; -------------------------------------------
  for ThisSizeIndex, CheckFileSize in FileArray
  {
    ; -------------------------------------------
    if FileExist(CheckFileSize)
    {
      FileGetSize, ThisSize, %CheckFileSize%
    }
    else
    {
      ThisSize := 0
    }
    ; -------------------------------------------
    TotalNow := TotalNow + ThisSize
    ; -------------------------------------------
  } ; [End] for ThisSizeIndex, CheckFileSize in FileArray
  ; -------------------------------------------
  ThisPercent := (TotalNow / TotalSize) * 100
  ; -------------------------------------------
  return ThisPercent
  ; -------------------------------------------
} ; [End] GetPercentArray(FileArray, TotalSize) ; > ThisPercent
; -------------------------------------------
HttpQueryInfo(URL, QueryInfoFlag=21, Proxy="", ProxyBypass="")
{
  hModule := DllCall("LoadLibrary", "str", dll := "wininet.dll")
  ver := ( A_IsUnicode && !RegExMatch( A_AhkVersion, "\d+\.\d+\.4" ) ? "W" : "A" )
  InternetOpen := dll "\InternetOpen" ver
  HttpQueryInfo := dll "\HttpQueryInfo" ver
  InternetOpenUrl := dll "\InternetOpenUrl" ver
  if (Proxy != "")
  AccessType=3
  Else
  AccessType=1
  io_hInternet := DllCall( InternetOpen, "str", "" , "uint", AccessType, "str", Proxy, "str", ProxyBypass, "uint", 0) ;dwFlags
  if (ErrorLevel != 0 or io_hInternet = 0)
  {
    DllCall("FreeLibrary", "uint", hModule)
    return, -1
  }
  iou_hInternet := DllCall( InternetOpenUrl, "uint", io_hInternet, "str", url, "str", "", "uint", 0, "uint", 0x80000000, "uint", 0)
  if (ErrorLevel != 0 or iou_hInternet = 0)
  {
    DllCall("FreeLibrary", "uint", hModule)
    return, -1
  }
  VarSetCapacity(buffer, 1024, 0)
  VarSetCapacity(buffer_len, 4, 0)
  Loop, 5
  {
    hqi := DllCall( HttpQueryInfo, "uint", iou_hInternet, "uint", QueryInfoFlag, "uint", &buffer, "uint", &buffer_len, "uint", 0)
    if (hqi = 1)
    {
      hqi=success
      break
    }
  }
  ifNotEqual, hqi, success, SetEnv, res, timeout
  if (hqi = "success")
  {
    p := &buffer
    Loop
    {
      l := DllCall("lstrlen", "UInt", p)
      VarSetCapacity(tmp_var, l+1, 0)
      DllCall("lstrcpy", "Str", tmp_var, "UInt", p)
      p += l + 1 
      res := res . tmp_var
      if (*p = 0)
      Break
    }
  }
  DllCall("wininet\InternetCloseHandle",  "uint", iou_hInternet)
  DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
  DllCall("FreeLibrary", "uint", hModule)
  return, res
} ; [Function] (HttpQueryInfo)(URL, QueryInfoFlag=21, Proxy="", ProxyBypass="")
; -------------------------------------------
Install_ConnectCheck(flag=0x40) ; > [0/1]
{
  return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}
; -------------------------------------------
SetCounter(wParam, lParam)
{
	progress := Round(wParam / lParam * 113)
	GuiControl, , ProgressBar, %progress%
	GuiControl, , ProgressN, %progress%`%
	wParam := wParam // 1000
	lParam := lParam // 1000
	GuiControl, , KB, (%wParam%kb of %lParam%kb)
  Gui, Show, w470 h28, Downloading
} ; [End] SetCounter(wParam, lParam)
;-------------------------------------------
ToolTipMsg(UserLang, ThisTooltipMsg)
{
	; -------------------------------------------
  ToolTip
	; -------------------------------------------
	MsgLen := StrLen(ThisTooltipMsg)
	MovPos := MsgLen * 3
	; -------------------------------------------
	TTPTX := (A_ScreenWidth / 2) - MovPos
	TTPTY := (A_ScreenHeight / 2)
  ; -------------------------------------------
	CoordMode, ToolTip, Screen
	ToolTip, %ThisTooltipMsg%, TTPTX, TTPTY
	; -------------------------------------------
}
; -------------------------------------------
; [FUNCTIONS]
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [FIRST] Get Language
; -------------------------------------------
UserLang := GetLangInstall() ; > UserLang
; -------------------------------------------
; [FIRST] Get Language
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Tool Tip Message "Checking Internet Connection"
; -------------------------------------------
if (UserLang == "de") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Internetverbindung prüfen"
}
else if (UserLang == "en") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Checking Internet Connection"
}
else if (UserLang == "es") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Comprobación de la conexión a Internet"
}
else if (UserLang == "fr") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Vérification de la connexion Internet"
}
else if (UserLang == "it") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Verifica della connessione a Internet"
}
else if (UserLang == "pl") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Sprawdzanie połączenia internetowego"
}
else if (UserLang == "pt") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Verificando a conexão com a Internet"
}
else if (UserLang == "ru") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Проверка подключения к Интернету"
}
else if (UserLang == "sv") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Kontrollerar Internetanslutning"
}
else if (UserLang == "tr") ; "Checking Internet Connection"
{
  ThisTooltipMsg := "İnternet Bağlantısını Kontrol Etme"
}
else ; "Checking Internet Connection"
{
  ThisTooltipMsg := "Checking Internet Connection"
}
; -----------------------------------------
ToolTipMsg(UserLang, ThisTooltipMsg)
; -------------------------------------------
; Tool Tip Message "Checking Internet Connection"
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [FIRST] Check it There is a Internet Connection -OR- (ExitApp)
; -------------------------------------------
HasInternetConnection := Install_ConnectCheck(flag=0x40) ; > [0/1]
; -------------------------------------------
if (HasInternetConnection == 0) ; [ERROR] (M1)(MsgBox)(No Internet Connection)
{
  ; -------------------------------------------
  if (UserLang == "de")
  {
    MsgBox, 262192, Keine Internetverbindung, (M1) Es gibt keine Internetverbindung`n`nMuss über eine Internetverbindung verfügen,`num PopUpMenu zu installieren, 5
  }
  else if (UserLang == "en")
  {
    MsgBox, 262192, No Internet Connection, (M1) There is No Internet Connection`n`nMust have Internet Connection`nto Install PopUpMenu, 5
  }
  else if (UserLang == "es")
  {
    MsgBox, 262192, Sin conexión a Internet, (M1) No hay conexión a internet`n`nDebe tener conexión a internet`npara instalar PopUpMenu, 5
  }
  else if (UserLang == "fr")
  {
    MsgBox, 262192, Pas de connexion Internet, (M1) Il n'y a pas de connexion Internet`n`nDoit avoir une connexion Internet`npour installer PopUpMenu, 5
  }
  else if (UserLang == "it")
  {
    MsgBox, 262192, Nessuna connessione internet, (M1) Non c'è connessione internet`n`nDeve avere una connessione Internet`nper installare PopUpMenu, 5
  }
  else if (UserLang == "pl")
  {
    MsgBox, 262192, Brak polaczenia z internetem, (M1) Nie ma polaczenia z Internetem`n`nMusi miec polaczenie z Internetem,`naby zainstalowac PopUpMenu, 5
  }
  else if (UserLang == "pt")
  {
    MsgBox, 262192, Nenhuma conexão com a Internet, (M1) Não há conexão com a Internet`n`nDeve ter conexão com a internet`npara instalar PopUpMenu, 5
  }
  else if (UserLang == "ru")
  {
    MsgBox, 262192, Нет подключения к Интернету, (M1) Нет подключения к Интернету`n`nДолжно быть подключение к Интернету`nдля установки PopUpMenu, 5
  }
  else if (UserLang == "sv")
  {
    MsgBox, 262192, Ingen internetanslutning, (M1) Det finns ingen internetanslutning`n`nMåste ha internetanslutning för`natt installera PopUpMenu, 5
  }
  else if (UserLang == "tr")
  {
    MsgBox, 262192, Internet baglantisi yok, (M1) Internet baglantisi yok`n`nPopUpMenu yüklemek için internet`nbaglantisi olmali, 5
  }
  else
  {
    MsgBox, 262192, No Internet Connection, (M1) There is No Internet Connection`n`nMust have Internet Connection`nto Install PopUpMenu, 5
  }
  ; -------------------------------------------
  ExitApp ; (MsgBox)(No Internet Connection)
  ; -------------------------------------------
} ; [End] if (HasInternetConnection == 0) ; [ERROR] (MsgBox)(No Internet Connection)
; -------------------------------------------
; [FIRST] Check it There is a Internet Connection -OR- (ExitApp)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [FOLDER] [CREATE] for Installer file and Images
; -------------------------------------------
InstallFolder := A_Temp "\PopUpMenu"
CheckedForAdmin := A_Temp "\PopUpMenu\CheckedForAdmin.txt"
; -------------------------------------------
FileRemoveDir, %InstallFolder%, 1
Sleep, 100
FileCreateDir, %InstallFolder%
; -------------------------------------------
; [FOLDER] [CREATE] for Installer file and Images
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Tool Tip Message "Checking User Privileges"
; -------------------------------------------
if (UserLang == "de") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Benutzerurivileges prüfen"
}
else if (UserLang == "en") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Checking User Privileges"
}
else if (UserLang == "es") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Comprobación de privilegios de usuario"
}
else if (UserLang == "fr") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Vérification des privilèges utilisateur"
}
else if (UserLang == "it") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Verifica dei privilegi utente"
}
else if (UserLang == "pl") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Sprawdzanie uprawnień użytkownika"
}
else if (UserLang == "pt") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Verificando os privilégios do usuário"
}
else if (UserLang == "ru") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Проверка привилегий пользователя"
}
else if (UserLang == "sv") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Kontrollera användarrättigheter"
}
else if (UserLang == "tr") ; "Checking User Privileges"
{
  ThisTooltipMsg := "Kullanıcı Ayrıcalıklarını Kontrol Etme"
}
else ; "Checking User Privileges"
{
  ThisTooltipMsg := "Checking User Privileges"
}
; -----------------------------------------
ToolTipMsg(UserLang, ThisTooltipMsg)
; -------------------------------------------
; Tool Tip Message "Checking User Privileges"
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; (IF) Not Admin - (TRY) to ReLoad "As Admin" -OR- (ExitApp)
; -------------------------------------------
if (A_IsAdmin == 0) ; Script is NOT Running as Admin
{
	; -------------------------------------------
	if !FileExist(CheckedForAdmin) ; First Time that this script has ran, with no Admin Rights
	{
		; -------------------------------------------
		FileAppend, 1, CheckedForAdmin
		; -------------------------------------------
		Run, *RunAs %A_ScriptFullPath%
		; -------------------------------------------
	} ; First Time that this script has ran, with no Admin Rights
	; -------------------------------------------
	;
	; -------------------------------------------
	if FileExist(CheckedForAdmin) ; (MsgBox)(Failed)(NO Admin Rights)(ExitApp) | After Having Tired to Load As Admin but Did Not Work, Script Still Not Running As Admin
	{
		; -------------------------------------------
		FileRemoveDir, %A_Temp%\PopUpMenu, 1
		; -------------------------------------------
		;
		; -------------------------------------------
		if (UserLang == "de") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Systemfehler, Sie haben keine Administratorrechte, 5
		}
		else if (UserLang == "en") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, System Error, You Do Not have Administrator Rights, 5
		}
		else if (UserLang == "es") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Error del sistema, No tienes derechos de administrador, 5
		}
		else if (UserLang == "fr") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Erreur système, Vous n'avez pas les droits d'administrateur, 5
		}
		else if (UserLang == "it") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Errore di sistema, Non hai i diritti di amministratore, 5
		}
		else if (UserLang == "pl") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Blad systemu, Nie masz uprawnień administratora, 5
		}
		else if (UserLang == "pt") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Erro no sistema, Você não tem direitos de administrador, 5
		}
		else if (UserLang == "ru") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Системная ошибка, У вас нет прав администратора, 5
		}
		else if (UserLang == "sv") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Systemfel, Du har inga administratörsrättigheter, 5
		}
		else if (UserLang == "tr") ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, Sistem hatasi, Yönetici Haklarınız Yok, 5
		}
		else ; You Do Not have Administrator Rights
		{
			MsgBox, 262192, System Error, You Do Not have Administrator Rights, 5
		}
		; -------------------------------------------
		;
		; -------------------------------------------
		ExitApp ; (MsgBox)(Failed)(NO Admin Rights)
		; -------------------------------------------
	} ; (ExitApp)
	; -------------------------------------------
} ; Script is NOT Running as Admin
; -------------------------------------------
; (IF) Not Admin - (TRY) to ReLoad "As Admin" -OR- (ExitApp)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Tool Tip Message "Installer Start Up"
; -------------------------------------------
if (UserLang == "de") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Start des Installationsprogramms"
}
else if (UserLang == "en") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Installer Start Up"
}
else if (UserLang == "es") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Puesta en marcha del instalador"
}
else if (UserLang == "fr") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Démarrage de l'installateur"
}
else if (UserLang == "it") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Avvio del programma di installazione"
}
else if (UserLang == "pl") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Uruchomienie instalatora"
}
else if (UserLang == "pt") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Inicialização do Instalador"
}
else if (UserLang == "ru") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Запуск установщика"
}
else if (UserLang == "sv") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Installationsstart"
}
else if (UserLang == "tr") ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Yükleyici Başlatma"
}
else ; "Installer Start Up"
{
  ThisTooltipMsg := "PopUpMenu Installer Start Up"
}
; -----------------------------------------
ToolTipMsg(UserLang, ThisTooltipMsg)
; -------------------------------------------
; Tool Tip Message "Installer Start Up"
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; -------------------------------------------
DeleteMe := A_ScriptDir "\CheckedForAdmin"
FileDelete, %DeleteMe%
; -------------------------------------------
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [Download] AutoHotkey Installer
; -------------------------------------------
Url_AutoHotkeyInstaller := "https://ZarephathBarlow.github.io/support/AutoHotkey.exe"
Exe_AutoHotkeyInstaller := A_Temp "\PopUpMenu\AutoHotkey.exe"
Downloaded_OK := DownloadFile(Url_AutoHotkeyInstaller, Exe_AutoHotkeyInstaller)
Sleep, 500
; -------------------------------------------
; [Download] AutoHotkey Installer
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [Download][Install] AutoHotkey -OR- (ExitApp)
; -------------------------------------------
if (Downloaded_OK == 1 && FileExist(Exe_AutoHotkeyInstaller)) ; Exe_AutoHotkeyInstaller Downloaded - (OK) Continue
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; [Install] AutoHotkey
  ; -------------------------------------------
  RunWait,*RunAs %Exe_AutoHotkeyInstaller% /s
  ; -------------------------------------------
  Sleep, 500
  ; -------------------------------------------
  ; [Install] AutoHotkey
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
} ; Exe_AutoHotkeyInstaller Downloaded - (OK) Continue
else ; [ERROR] (ExitApp) (AutoHotkey.exe) Was not downloaded
{
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ; -------------------------------------------
  if (UserLang == "de") ; Installer Failed
  {
    MsgBox, 262192, Systemfehler, Installer fehlgeschlagen, 5
  }
  else if (UserLang == "en") ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  else if (UserLang == "es") ; Installer Failed
  {
    MsgBox, 262192, Error del sistema, Instalador falló, 5
  }
  else if (UserLang == "fr") ; Installer Failed
  {
    MsgBox, 262192, Erreur système, L'installateur a échoué, 5
  }
  else if (UserLang == "it") ; Installer Failed
  {
    MsgBox, 262192, Errore di sistema, Installer non riuscito, 5
  }
  else if (UserLang == "pl") ; Installer Failed
  {
    MsgBox, 262192, Blad systemu, Instalator nie powiódl sie, 5
  }
  else if (UserLang == "pt") ; Installer Failed
  {
    MsgBox, 262192, Erro no sistema, Instalador falhou, 5
  }
  else if (UserLang == "ru") ; Installer Failed
  {
    MsgBox, 262192, Системная ошибка, Сбой установщика, 5
  }
  else if (UserLang == "sv") ; Installer Failed
  {
    MsgBox, 262192, Systemfel, Installer misslyckades, 5
  }
  else if (UserLang == "tr") ; Installer Failed
  {
    MsgBox, 262192, Sistem hatasi, Yükleyici basarisiz oldu, 5
  }
  else ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  ; -------------------------------------------
  ExitApp ; (MsgBox)(Download Failed) domain_installer.txt
  ; -------------------------------------------
} ; [ERROR] (ExitApp) (AutoHotkey.exe) Was not downloaded
; -------------------------------------------
; [Download][Install] AutoHotkey -OR- (ExitApp)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; (CHECK) (IF) AutoHotkey is Installed -OR- (ExitApp)
; -------------------------------------------
RegRead, CheckInstalledFolder, HKLM, SOFTWARE\AutoHotkey, InstallDir
Sleep, 100
; -------------------------------------------
if !FileExist(CheckInstalledFolder) ; AutoHotkey is NOT Installed
{
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ; -------------------------------------------
  if (UserLang == "de") ; Installer Failed
  {
    MsgBox, 262192, Systemfehler, Installer fehlgeschlagen, 5
  }
  else if (UserLang == "en") ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  else if (UserLang == "es") ; Installer Failed
  {
    MsgBox, 262192, Error del sistema, Instalador falló, 5
  }
  else if (UserLang == "fr") ; Installer Failed
  {
    MsgBox, 262192, Erreur système, L'installateur a échoué, 5
  }
  else if (UserLang == "it") ; Installer Failed
  {
    MsgBox, 262192, Errore di sistema, Installer non riuscito, 5
  }
  else if (UserLang == "pl") ; Installer Failed
  {
    MsgBox, 262192, Blad systemu, Instalator nie powiódl sie, 5
  }
  else if (UserLang == "pt") ; Installer Failed
  {
    MsgBox, 262192, Erro no sistema, Instalador falhou, 5
  }
  else if (UserLang == "ru") ; Installer Failed
  {
    MsgBox, 262192, Системная ошибка, Сбой установщика, 5
  }
  else if (UserLang == "sv") ; Installer Failed
  {
    MsgBox, 262192, Systemfel, Installer misslyckades, 5
  }
  else if (UserLang == "tr") ; Installer Failed
  {
    MsgBox, 262192, Sistem hatasi, Yükleyici basarisiz oldu, 5
  }
  else ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  ; -------------------------------------------
  ExitApp ; (MsgBox)(Download Failed) domain_installer.txt
  ; -------------------------------------------
} ; AutoHotkey is NOT Installed
; -------------------------------------------
; (CHECK) (IF) AutoHotkey is Installed -OR- (ExitApp)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Vars
; -------------------------------------------
InstallComplete := 0 ; Program only
global HadError := 0
global CountDownNum := 9 ; Start Frame Number
global CountDownShow := 1 ; Show
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [DOWNLOAD] (domain_installer.txt) -OR- (ExitApp)
; -------------------------------------------
Url_DomainInstaller := "https://midnightitsalmost.github.io/system/domain_installer.txt"
Txt_DomainInstaller := A_Temp "\PopUpMenu\domain_installer.txt"
Downloaded_OK := DownloadFile(Url_DomainInstaller, Txt_DomainInstaller)
; -------------------------------------------
;
; -------------------------------------------
if (Downloaded_OK == 0) ; [ERROR] (M2)(MsgBox)(Download Failed) domain_installer.txt
{
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ; -------------------------------------------
  if (UserLang == "de") ; Installer Failed
  {
    MsgBox, 262192, Systemfehler, Installer fehlgeschlagen, 5
  }
  else if (UserLang == "en") ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  else if (UserLang == "es") ; Installer Failed
  {
    MsgBox, 262192, Error del sistema, Instalador falló, 5
  }
  else if (UserLang == "fr") ; Installer Failed
  {
    MsgBox, 262192, Erreur système, L'installateur a échoué, 5
  }
  else if (UserLang == "it") ; Installer Failed
  {
    MsgBox, 262192, Errore di sistema, Installer non riuscito, 5
  }
  else if (UserLang == "pl") ; Installer Failed
  {
    MsgBox, 262192, Blad systemu, Instalator nie powiódl sie, 5
  }
  else if (UserLang == "pt") ; Installer Failed
  {
    MsgBox, 262192, Erro no sistema, Instalador falhou, 5
  }
  else if (UserLang == "ru") ; Installer Failed
  {
    MsgBox, 262192, Системная ошибка, Сбой установщика, 5
  }
  else if (UserLang == "sv") ; Installer Failed
  {
    MsgBox, 262192, Systemfel, Installer misslyckades, 5
  }
  else if (UserLang == "tr") ; Installer Failed
  {
    MsgBox, 262192, Sistem hatasi, Yükleyici basarisiz oldu, 5
  }
  else ; Installer Failed
  {
    MsgBox, 262192, System Error, Installer Failed, 5
  }
  ; -------------------------------------------
  ExitApp ; (MsgBox)(Download Failed) domain_installer.txt
  ; -------------------------------------------
} ; [End] if (Downloaded_OK == 0) ; [ERROR] (MsgBox)(Download Failed) domain_installer.txt
; -------------------------------------------
; [DOWNLOAD] (domain_installer.txt) -OR- (ExitApp)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; (Download Support Files) (Process Bar)
; -------------------------------------------
FileReadLine, DomainInstaller, %Txt_DomainInstaller%, 1
; -------------------------------------------
Url_1 := DomainInstaller "/install/installer_common.zip"
Url_2 := DomainInstaller "/install/installer_common_" UserLang ".zip"
Url_3 := DomainInstaller "/install/installer_program_common.zip"
Url_4 := DomainInstaller "/install/installer_program_" UserLang ".zip"
ArrayUrl := [Url_1, Url_2, Url_3, Url_4]
; -------------------------------------------
File_1 := A_Temp "\PopUpMenu\installer_common.zip"
File_2 := A_Temp "\PopUpMenu\installer_common_" UserLang ".zip"
File_3 := A_Temp "\PopUpMenu\installer_program_common.zip"
File_4 := A_Temp "\PopUpMenu\installer_installer_program_" UserLang ".zip"
ArrayFile := [File_1, File_2, File_3, File_4]
; -------------------------------------------
ToolTip
DownloadSupportProcessBar(ArrayUrl, ArrayFile)
; -------------------------------------------
; (Download Support Files) (Process Bar)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Wait until (Downloaded Support Files) Exist
; -------------------------------------------
BreakTime := A_TickCount + 3000
; -------------------------------------------
while (!FileExist(File_1) or !FileExist(File_2) or !FileExist(File_3) or !FileExist(File_4))
{
  if (A_TickCount > BreakTime)
  {
    break
  } ; [End] if (A_TickCount > BreakTime)
} ; [End] while (!FileExist(File_1) or !FileExist(File_2) or !FileExist(File_3) or !FileExist(File_4))
; -------------------------------------------
; Wait until (Downloaded Support Files) Exist
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Check (Downloaded Support Zips) Exist
; if NOT Set HadError := 1
; -------------------------------------------
for index, ThisFile in ArrayFile
{
  if !FileExist(ThisFile)
  {
    HadError := 1
  } ; [End] if FileExist(ThisFile)
} ; [End] for index, ThisFile in ArrayFile
; -------------------------------------------
; Check (Downloaded Support Zips) Exist
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [CHECK]/[UNZIP] (Download Support Files)
; -------------------------------------------
if (HadError == 1) ; There Was a Error
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Send Email About Error
  ; -------------------------------------------
  ErrorNum := ErrorGUI(UserLang, "(Downloaded Support Zips)(Missing)", InstallerNumber, "Program", "", "") ; "EX" or "Text" NO (CountDown)
  ; -------------------------------------------
  ; Send Email About Error
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; -------------------------------------------
  if (UserLang == "de")
  {
    MsgBox, 262192, Systemfehler, (M3) Installer fehlgeschlagen, 5
  }
  else if (UserLang == "en")
  {
    MsgBox, 262192, System Error, (M3) Installer Failed, 5
  }
  else if (UserLang == "es")
  {
    MsgBox, 262192, Error del sistema, (M3) Instalador falló, 5
  }
  else if (UserLang == "fr")
  {
    MsgBox, 262192, Erreur système, (M3) L'installateur a échoué, 5
  }
  else if (UserLang == "it")
  {
    MsgBox, 262192, Errore di sistema, (M3) Installer non riuscito, 5
  }
  else if (UserLang == "pl")
  {
    MsgBox, 262192, Blad systemu, (M3) Instalator nie powiódl sie, 5
  }
  else if (UserLang == "pt")
  {
    MsgBox, 262192, Erro no sistema, (M3) Instalador falhou, 5
  }
  else if (UserLang == "ru")
  {
    MsgBox, 262192, Системная ошибка, (M3) Сбой установщика, 5
  }
  else if (UserLang == "sv")
  {
    MsgBox, 262192, Systemfel, (M3) Installer misslyckades, 5
  }
  else if (UserLang == "tr")
  {
    MsgBox, 262192, Sistem hatasi, (M3) Yükleyici basarisiz oldu, 5
  }
  else
  {
    MsgBox, 262192, System Error, (M3) Installer Failed, 5
  }
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ExitApp ; (MsgBox)(Download Failed)(ThisApp "_" ThisLang ".zip")
  ; -------------------------------------------
} ; [End] if (HadError == 1) ; There Was a Error
else ; UnZip (Download Support Files)
{
  ; -------------------------------------------
  InstallTempFolder := A_Temp "\PopUpMenu"
  ; -------------------------------------------
  for index, ThisZip in ArrayFile
  {
    File_UnZip(ThisZip, InstallFolder) ; (ZipFile, UnZipDir)
  }
  ; -------------------------------------------
} ; [End] else ; UnZip (Download Support Files)
; -------------------------------------------
; [CHECK]/[UNZIP] (Download Support Files)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
{ ; [SET] [VARS] FilePaths [Program]
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_program_" UserLang ".zip"
  Image_Message_1 := A_Temp "\PopUpMenu\Message_1_" UserLang ".png" ; (This Will Install) [Plugin]/[PopUpMenu]
  Image_Message_2 := A_Temp "\PopUpMenu\Message_2_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_3 := A_Temp "\PopUpMenu\Message_3_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_4 := A_Temp "\PopUpMenu\Message_4_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_5 := A_Temp "\PopUpMenu\Message_5_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_6 := A_Temp "\PopUpMenu\Message_6_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_7 := A_Temp "\PopUpMenu\Message_7_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_8 := A_Temp "\PopUpMenu\Message_8_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_9 := A_Temp "\PopUpMenu\Message_9_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_10 := A_Temp "\PopUpMenu\Message_10_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_11 := A_Temp "\PopUpMenu\Message_11_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_12 := A_Temp "\PopUpMenu\Message_12_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_13 := A_Temp "\PopUpMenu\Message_13_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_14 := A_Temp "\PopUpMenu\Message_14_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_15 := A_Temp "\PopUpMenu\Message_15_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_16 := A_Temp "\PopUpMenu\Message_16_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_17 := A_Temp "\PopUpMenu\Message_17_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_18 := A_Temp "\PopUpMenu\Message_18_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_19 := A_Temp "\PopUpMenu\Message_19_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_20 := A_Temp "\PopUpMenu\Message_20_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_21 := A_Temp "\PopUpMenu\Message_21_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_22 := A_Temp "\PopUpMenu\Message_22_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_23 := A_Temp "\PopUpMenu\Message_23_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_24 := A_Temp "\PopUpMenu\Message_24_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_25 := A_Temp "\PopUpMenu\Message_25_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_26 := A_Temp "\PopUpMenu\Message_26_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_27 := A_Temp "\PopUpMenu\Message_27_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_28 := A_Temp "\PopUpMenu\Message_28_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_29 := A_Temp "\PopUpMenu\Message_29_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_30 := A_Temp "\PopUpMenu\Message_30_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_31 := A_Temp "\PopUpMenu\Message_31_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  Image_Message_32 := A_Temp "\PopUpMenu\Message_32_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  ; -------------------------------------------
  Image_Message_E2 := A_Temp "\PopUpMenu\Message_E2_" UserLang ".png" ; ([Plugin] Info About AddonProcessName/UserLang)/([Program] Please be patient)
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_program_" UserLang ".zip"
  ;
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_program_common.zip"
  Script_DeleteFolderPopUpMenu := A_Temp "\PopUpMenu\DeleteFolderPopUpMenu.ahk"
  Script_UnZip := A_Temp "\PopUpMenu\Script_UnZip.ahk"
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_program_common.zip"
  ;
  ;  
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common_" UserLang ".zip"
  Image_Button_Yes := A_Temp "\PopUpMenu\ButtonLeft_Yes_" UserLang ".png"
  Image_Button_Cancel := A_Temp "\PopUpMenu\ButtonRight_Cancel_" UserLang ".png"
  Image_Button_Finish := A_Temp "\PopUpMenu\ButtonRight_Finish_" UserLang ".png"
  Image_Button_No := A_Temp "\PopUpMenu\ButtonRight_No_" UserLang ".png"
  ; -------------------------------------------
  Image_Message_0 := A_Temp "\PopUpMenu\Message_0_" UserLang ".png" ; (Loading PopUpMenu)
  ; -------------------------------------------
  Image_Error_E1 := A_Temp "\PopUpMenu\Message_E1_" UserLang ".png" ; (E1 Install Failed)
  Image_Error_E3 := A_Temp "\PopUpMenu\Message_E3_" UserLang ".png" ; (E3 No Internet Connection)
  Image_Error_E4 := A_Temp "\PopUpMenu\Message_E4_" UserLang ".png" ; (E4 No Admin Rights)
  Image_Error_E5 := A_Temp "\PopUpMenu\Message_E5_" UserLang ".png" ; (E5)(Download Failed)
  Image_Error_E6 := A_Temp "\PopUpMenu\Message_E6_" UserLang ".png" ; (E6 Installer Expired)
  Image_Error_E7 := A_Temp "\PopUpMenu\Message_E7_" UserLang ".png" ; (E7)(PopUpMenu Not Installed)
  Image_Error_EX := A_Temp "\PopUpMenu\Message_EX_" UserLang ".png" ; (E6 Installer Expired)
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common_" UserLang ".zip"
  ;
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common.zip"
  Image_Count_0 := A_Temp "\PopUpMenu\Count_0.png"
  Image_Count_1 := A_Temp "\PopUpMenu\Count_1.png"
  Image_Count_2 := A_Temp "\PopUpMenu\Count_2.png"
  Image_Count_3 := A_Temp "\PopUpMenu\Count_3.png"
  Image_Count_4 := A_Temp "\PopUpMenu\Count_4.png"
  Image_Count_5 := A_Temp "\PopUpMenu\Count_5.png"
  Image_Count_6 := A_Temp "\PopUpMenu\Count_6.png"
  Image_Count_7 := A_Temp "\PopUpMenu\Count_7.png"
  Image_Count_8 := A_Temp "\PopUpMenu\Count_8.png"
  Image_Count_9 := A_Temp "\PopUpMenu\Count_9.png"
  Image_Count_10 := A_Temp "\PopUpMenu\Count_10.png"
  ; -------------------------------------------
  Image_GuiBG := A_Temp "\PopUpMenu\GuiBG.png"
  ; -------------------------------------------
  Image_PopUpMenu_Logo := A_Temp "\PopUpMenu\PopUpMenu.png"
  ; -------------------------------------------
  PopUpMenu_MailSend := A_Temp "\PopUpMenu\PopUpMenu_MailSend.exe"
  ; -------------------------------------------
  Image_ProcessWeb := A_Temp "\PopUpMenu\Process_Web.png"
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common.zip"
} ; [SET] [VARS] FilePaths [Program]
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [GUI] [INSTALLER] (Objects)
; -------------------------------------------
Gui, Margin , 0, 0
; -------------------------------------------
Gui, Add, Picture, x0   y0   w600 h400, %Image_GuiBG% ; Blank White Background
; -------------------------------------------
;
; -------------------------------------------
Gui, Add, Picture, x20  y350 w470 h34     vVar_WebLink,
Gui Add, Progress, x20  y362 w470 cbe37f0 vVar_ProgressBar,
; -------------------------------------------
;
; -------------------------------------------
Gui, Add, Picture, x496 y354 w87  h30   vVar_ButtonRight gLabel_ButtonRight, 
Gui, Add, Picture, x16  y354 w87  h30   vVar_ButtonLeft  gLabel_ButtonLeft,
; -------------------------------------------
;
; -------------------------------------------
Gui, Add, Picture, x20  y84  w560 h260  vVar_Message, %Image_Message_0% ; (Loading PopUpMenu)
; -------------------------------------------
Gui, Add, Picture, x284 y352 w32  h30   vVar_CountDown,
; -------------------------------------------
;
; -------------------------------------------
Gui, +LastFound -Caption +AlwaysOnTop +ToolWindow -Border
Gui, Color, 000000
WinSet, TransColor, 000000
Gui, Show
; -------------------------------------------
; [GUI] [INSTALLER] (Objects)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Hide All Objects
; -------------------------------------------
GuiControl, Hide, Var_CountDown
GuiControl, Hide, Var_ButtonRight
GuiControl, Hide, Var_ButtonLeft
GuiControl, Hide, Var_WebLink
GuiControl, Hide, Var_ProgressBar
; -------------------------------------------
; Hide All Objects
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [CHECK] (Admin Rights)
if (A_IsAdmin == 0) ; The Current User Does Not have Admin Rights
{
  ; -------------------------------------------
  HadError := 1
  ; -------------------------------------------
  ErrorNum := ErrorGUI(UserLang, "E4", InstallerNumber, "Program", "", "") ; (E4)(NO Admin Rights)
  ; -------------------------------------------
}
; -------------------------------------------
; [CHECK] (Admin Rights)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if (HadError == 0) ; (OK) (Admin Rights)
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
  ; [CHECK] (PopUpMenu Installed), if 1 (E2 Already Installed)
  ; ------------------------------------------- [Program]
  InStalledPopUpMenuFolder := A_ProgramFiles "\PopUpMenu_PUM"
  ; ------------------------------------------- [Program]
  if FileExist(InStalledPopUpMenuFolder) ; [ERROR] (E2 Already Installed)
  {
    ; ------------------------------------------- [Program]
    HadError := 1
    ; ------------------------------------------- [Program]
    ErrorNum := ErrorGUI(UserLang, "E2", InstallerNumber, "Program", "", "") ; (E2)(Already Installed)
    ; ------------------------------------------- [Program]
  } ; [End] if FileExist(InStalledPopUpMenuFolder) ; [ERROR] (E2 Already Installed)
  ; ------------------------------------------- [Program]
  ; [CHECK] (PopUpMenu Installed), if 1 (E2 Already Installed)
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
  ;
  if (HadError == 0) ; (OK) (NOT) (Already Installed)
  {
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
    ; [DOWNLOAD] (domain_installprogram.txt) Domain for Install (Program Zips)
    ; ------------------------------------------- [Program]
    Url_DomainInstall := "https://midnightitsalmost.github.io/system/domain_installprogram.txt"
    File_DomainZipInstall := A_Temp "\PopUpMenu\domain_installprogram.txt"
    Downloaded_OK := DownloadFile(Url_DomainInstall, File_DomainZipInstall)
    ; ------------------------------------------- [Program]
    ; [DOWNLOAD] (domain_installprogram.txt) Domain for Install (Program Zips)
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
    ; [CHECK] (Downloaded_OK) (domain_installprogram.txt), if 0 (E5)(Download Failed)
    ; ------------------------------------------- [Program]
    if (Downloaded_OK == 0) ; (domain_installprogram.txt) Was NOT Downloaded
    {
      ; ------------------------------------------- [Program]
      HadError := 1
      ; ------------------------------------------- [Program]
      ErrorNum := ErrorGUI(UserLang, "E5", InstallerNumber, "Program", "", "") ; (E5)(Download Failed)
      ; ------------------------------------------- [Program]
    } ; [End] if (Downloaded_OK == 0) ; (domain_installprogram.txt) Was NOT Downloaded
    ; ------------------------------------------- [Program]
    ; [CHECK] (Downloaded_OK) (domain_installprogram.txt), if 0 (E5)(Download Failed)
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
    ;
    if (HadError == 0) ; (OK) (Download Failed)
    {
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
      ; [DOWNLOAD] (PopUpMenu_InstallerNumber.txt)
      ; [CHECK] (Installer Date), if NOT Exist (PopUpMenu_InstallerNumber.txt) (E6)(Installer Expired)
      ; ------------------------------------------- [Program]
      FileReadLine, DomainInstallZips, %File_DomainZipInstall%, 1
      Sleep, 100
      ; ------------------------------------------- [Program]
      Url_InstallerNumber := DomainInstallZips "/installzips/PopUpMenu_" InstallerNumber ".txt" ; InstallerNumber on Line 22
      File_InstallerNumber := A_Temp "\PopUpMenu\PopUpMenu_" InstallerNumber ".txt" ; InstallerNumber on Line 22
      ; -------------------------------------------
      Downloaded_OK := DownloadFile(Url_InstallerNumber, File_InstallerNumber)
      Sleep, 500
      ; ------------------------------------------- [Program]
      if (Downloaded_OK == 0 or !FileExist(File_InstallerNumber))
      {
        ; ------------------------------------------- [Program]
        HadError := 1
        ; -------------------------------------------
        ErrorNum := ErrorGUI(UserLang, "E6", InstallerNumber, "Program", "", "") ; (E6)(Installer Expired)
        ; ------------------------------------------- [Program]
      }
      ; ------------------------------------------- [Program]
      ; [DOWNLOAD] (PopUpMenu_InstallerNumber.txt)
      ; [CHECK] (Installer Date), if NOT Exist (PopUpMenu_InstallerNumber.txt) (E6)(Installer Expired)
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
      ;
      if (HadError == 0) ; (OK) (NOT) (Installer Expired)
      {
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        CheckedForAdmin := A_Temp "\PopUpMenu\CheckedForAdmin.txt"
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
        ; (Everything OK) (Ask to Install)
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Program]
        ;
        ; ------------------------------------------- [Program]
        FileReadLine, NumOfZips, %File_InstallerNumber%, 1 ; Get (NumOfZips) from (PopUpMenu_InstallerNumber.txt)
        ; ------------------------------------------- [Program]
        ;
        ; ------------------------------------------- [Program]
        GuiControl, Hide, Var_CountDown
        ; ------------------------------------------- [Program]
        GuiControl, , Var_ButtonLeft, %Image_Button_Yes% ; Image_Button_Yes := A_Temp "\PopUpMenu\ButtonLeft_Yes_" ThisLang ".png"
        GuiControl, Show, Var_ButtonLeft
        ; ------------------------------------------- [Program]
        ImageButtonRight := "No"
        GuiControl, , Var_ButtonRight, %Image_Button_No% ; Image_Button_No := A_Temp "\PopUpMenu\ButtonRight_No_" ThisLang ".png"
        GuiControl, Show, Var_ButtonRight
        ; ------------------------------------------- [Program]
        GuiControl, , Var_Message, %Image_Message_1% ; (This Will Install) [Plugin]/[PopUpMenu]
        GuiControl, Show, Var_Message
        ; ------------------------------------------- [Program]
        
        
        
        
        
        
        
        return ; return Here to End the Gui
        ; ------------------------------------------- [Program]
        ;
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; (Everything OK) (Ask to Install)
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      } ; [End] if (HadError == 0) ; (OK) (NOT) (Installer Expired)
    } ; [End] if (HadError == 0) ; (OK) (Download Failed)
  } ; [End] if (HadError == 0) ; (OK) (NOT) (Already Installed)
} ; [End] if (HadError == 0) ; (OK) (Admin Rights)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [GUI] [INSTALLER] (Labels)
; -------------------------------------------
Label_ProgressBar:
{
  ; -------------------------------------------
  if (PluginPercentArray != "")
  {
    ; -------------------------------------------
    if (PluginPercentArray.1 == "Number")
    {
      ThisPercent := ThisPercent + 2
    }
    else
    {
      ThisPercent := GetPercent(PluginPercentArray) ; > ThisPercent
    }
    ; -------------------------------------------
    if (ThisPercent >= 100)
    {
      GuiControl, , Var_ProgressBar, 100
    }
    else
    {
      GuiControl, , Var_ProgressBar, %ThisPercent%
    }
    GuiControl, Show, Var_ProgressBar
  } ; [End] if (PluginPercentArray != "")
}
return
Label_ButtonRight: ; ("No") ("Finish")
{
  if (ImageButtonRight == "No") ; [Common]
  {
    ; -------------------------------------------
    CancelInstall("", "Program", "", "") ; (User Said No)
    ; -------------------------------------------
  } ; [End] if (ImageButtonRight == "No") ; [Common]
  ; -------------------------------------------
  else if (ImageButtonRight == "Cancel") ; [Program]
  {
    ; -------------------------------------------
    WinGet, Gui_Id, ID , ahk_class AutoHotkeyGUI
    WinSet, AlwaysOnTop, Off, ahk_id %Gui_Id%
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    MessageShow := 0
    ; -------------------------------------------
    UserLang := GetLangInstall() ; > UserLang
    ; -------------------------------------------
    if (UserLang == "de")
    {
      MsgBox, 262436, PopUpMenu-Installation abbrechen, Sind Sie sicher, dass Sie die Installation von PopUpMenu stornieren möchten?
    }
    else if (UserLang == "en")
    {
      MsgBox, 262436, Cancel PopUpMenu Installation, Are You Sure You Want To Cancel PopUpMenu Installation?
    }
    else if (UserLang == "es")
    {
      MsgBox, 262436, Cancelar la instalación de PopUpMenu, ¿Está seguro de que desea cancelar la instalación de PopUpMenu?
    }
    else if (UserLang == "fr")
    {
      MsgBox, 262436, Annuler l'installation de PopUpMenu, Êtes-vous sûr de vouloir annuler l'installation de PopUpMenu?
    }
    else if (UserLang == "it")
    {
      MsgBox, 262436, Annulla l'installazione del PopUpMenu, Sei sicuro di voler cancellare l'installazione del PopUpMenu?
    }
    else if (UserLang == "pl")
    {
      MsgBox, 262436, Anuluj instalacje PopUpMenu, Czy na pewno chcesz anulowac instalacje PopUpMenu?
    }
    else if (UserLang == "pt")
    {
      MsgBox, 262436, Cancelar a instalação PopUpMenu, Tem certeza de que deseja cancelar a instalação PopUpMenu?
    }
    else if (UserLang == "ru")
    {
      MsgBox, 262436, Отмена установки PopUpMenu, Вы уверены, что хотите отменить установку PopUpMenu?
    }
    else if (UserLang == "sv")
    {
      MsgBox, 262436, Avbryt PopUpMenu Installation, Är du säker på att du vill avbryta PopUpMenu-installationen?
    }
    else if (UserLang == "tr")
    {
      MsgBox, 262436, PopUpMenu kurulumunu iptal et, PopUpMenu kurulumunu iptal etmek istediginizden emin misiniz?
    }
    ; -------------------------------------------
    IfMsgBox Yes
    {
      ; -------------------------------------------
      HadError := 1
      ; -------------------------------------------
      ErrorNum := ErrorGUI(UserLang, "EX", InstallerNumber, "Program", "", "") ; (EX)(User Pressed Cancel)
      ; -------------------------------------------
    }
    else
    {
      MessageShow := 1
      WinSet, AlwaysOnTop, On, ahk_id %Gui_Id%
    }
    ; -------------------------------------------
  } ; [End] else if (ImageButtonRight == "Cancel") ; [Program]
  ; -------------------------------------------
} ; [End] Label_ButtonRight:
return
Label_ButtonLeft: ; ("Yes") (Do Install)
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Hide objects
  ; -------------------------------------------
  GuiControl, Hide, Var_CountDown
  SetTimer, Label_CountDown, Off
  ; -------------------------------------------
  GuiControl, Hide, Var_ButtonLeft
  ; -------------------------------------------
  ; Hide objects
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Show objects
  ; -------------------------------------------
  ImageButtonRight := "Cancel"
  GuiControl, , Var_ButtonRight, %Image_Button_Cancel% ; Image_Button_Cancel := A_Temp "\PopUpMenu\ButtonRight_Cancel_" ThisLang ".png"
  GuiControl, Show, Var_ButtonRight
  ; -------------------------------------------
  ; Show objects
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Start Messages
  ; -------------------------------------------
  global MessageNum := 2 ; Start Frame Number 
  global MessageShow := 1 ; Show
  SetTimer, Label_Message, 100 ; Start Timer
  ; -------------------------------------------
  ; Start Messages
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Process Bar Var_ProgressBar
  ; ProcessAdd (The Amout to add to ProcessBar after each Completed Element)
  ; -------------------------------------------
  ProcessAdd := Round(100 / (NumOfZips * 2)) ; NumOfZips Set Above
  ProcessNum := 1
  ProcessPercent := ProcessAdd * ProcessNum
  ; -------------------------------------------
  GuiControl, , Var_ProgressBar, %ProcessPercent%
  GuiControl, Show, Var_ProgressBar
  ; -------------------------------------------
  ; Process Bar Var_ProgressBar
  ; ProcessAdd (The Amout to add to ProcessBar after each Completed Element)
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Download Zips (PopUpMenu_ZipNum_DayStamp.zip)
  ; [CREATE] [ARRAY] (ZipArray) of Zips to UnZip
  ; -------------------------------------------
  ZipArray := []
  ZipNum := 0
  ; -------------------------------------------
  if (HadError == 0)
  {
    if (NumOfZips == "")
    {
      File_InstallerNumber := A_Temp "\PopUpMenu\PopUpMenu_" InstallerNumber ".txt" ; InstallerNumber on Line 22
      FileReadLine, NumOfZips, %File_InstallerNumber%, 1
    }
  }
  ; -------------------------------------------
  Loop %NumOfZips%
  {
    ; -------------------------------------------
    ZipNum := ZipNum + 1
    ZipUrl := DomainInstallZips "/installzips/PopUpMenu_" ZipNum "_" InstallerNumber ".zip"
    ZipFile := A_Temp "\PopUpMenu\PopUpMenu_" ZipNum "_" InstallerNumber ".zip"
    ; -------------------------------------------
    if (HadError == 0)
    {
      ; -------------------------------------------
      Downloaded_OK := DownloadFile(ZipUrl, ZipFile) ; Download (PopUpMenu_ZipNum_DayStamp.zip)
      ; -------------------------------------------
      while (Downloaded_OK == 0) ; [WHILE LOOP] until (Downloaded_OK == 1)
      {
        ; -------------------------------------------
        HasInternetConnection := Install_ConnectCheck(flag=0x40) ; > [0/1]
        ; -------------------------------------------
        if (HasInternetConnection == 1)
        {
          ; -------------------------------------------
          Sleep, 500
          Downloaded_OK := DownloadFile(ZipUrl, ZipFile)
          ; -------------------------------------------
        } ; [End] if (HasInternetConnection == 1)
        else ; (E3 No Internet Connection)
        {
          ; -------------------------------------------
          HadError := 1
          ; -------------------------------------------
          ErrorNum := ErrorGUI(UserLang, "E3", InstallerNumber, "Program", "", "") ; (E3)(No Internet Connection)
          ; -------------------------------------------
          ZipArray := "" ; Empty This Value
          break ; [BREAK OUT] of while
          ; -------------------------------------------
        } ; [End] else ; (E3 No Internet Connection)
        ; -------------------------------------------
      } ; [End] while (Downloaded_OK == 0) ; [WHILE LOOP] until (Downloaded_OK == 1)
      ; -------------------------------------------
      if (HadError == 0)
      {
        ; -------------------------------------------
        ZipArray.Push(ZipFile) ; Add ZipFile to ZipArray
        ; -------------------------------------------
        ;
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; Process Bar
        ; -------------------------------------------
        ProcessNum := ProcessNum + 1
        ProcessPercent := ProcessAdd * ProcessNum
        ; -------------------------------------------
        if (ProcessPercent > 100)
        {
          ProcessPercent := 100
        }
        ; -------------------------------------------
        GuiControl, , Var_ProgressBar, %ProcessPercent%
        GuiControl, Show, Var_ProgressBar
        ; -------------------------------------------
        ; Process Bar
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      } ; [End] if (HadError == 0) ; Continue [NO DOWNLOAD ERROR]
      else ; (HadError != 0) (break Out of [LOOP] %NumOfZips%)
      {
        ; -------------------------------------------
        ZipArray := "" ; Empty This Value
        break ; [BREAK OUT] of [LOOP] %NumOfZips%
        ; -------------------------------------------
      } ; [End] if (HadError == 1)
      ; -------------------------------------------
      ; Continue (Downloaded_OK == 1)
      ; if There was a Error (HadError != 0) (break Out of [LOOP] %NumOfZips%)
      ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    } ; [End] if (HadError == 0)
  } ; [End] Loop %NumOfZips%
  ; -------------------------------------------
  ; Download Zips (PopUpMenu_ZipNum_DayStamp.zip)
  ; [CREATE] [ARRAY] (ZipArray) of Zips to UnZip
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; UnZip Zips 
  ; -------------------------------------------
  for Index, ZipFile in ZipArray ; UnZip Zips 
  {
    if (HadError == 0)
    {
      ; -------------------------------------------
      if FileExist(ZipFile) ; (PopUpMenu_ZipNum_" InstallerNumber ".zip") (Exist)
      {
        ; -------------------------------------------
        DoUnZip(ZipFile)
        ; -------------------------------------------
        Sleep, 500 ; Give time to complete Process
        ; -------------------------------------------
        FileDelete, %File_UnZipThis%
        ; -------------------------------------------
        Sleep, 500 ; Give time to complete Process
        ; -------------------------------------------
        ;
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; Process Bar
        ; -------------------------------------------
        ProcessNum := ProcessNum + 1
        ProcessPercent := ProcessAdd * ProcessNum
        ; -------------------------------------------
        if (ProcessPercent > 100)
        {
          ProcessPercent := 100
        }
        ; -------------------------------------------
        GuiControl, , Var_ProgressBar, %ProcessPercent%
        GuiControl, Show, Var_ProgressBar
        ; -------------------------------------------
        ; Process Bar
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      } ; [End] if FileExist(ZipFile)
      else ; Zip Missing [ERROR] (E5)(Download Failed) Zip File Missing
      {
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; Zip Missing [ERROR] Delete any Zips that were Downloaded
        ; -------------------------------------------
        for Index_2, ZipFile in ZipArray
        {
          ; -------------------------------------------
          FileDelete, %ZipFile%
          ; -------------------------------------------
        }
        ; -------------------------------------------
        ; Zip Missing [ERROR] Delete any Zips that were Downloaded
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;
        ; -------------------------------------------
        HadError := 1
        ; -------------------------------------------
        ; (PopUpMenu_ZipNum_DayStamp.zip") (Missing)
        ErrorNum := ErrorGUI(UserLang, "E5", InstallerNumber, "Program", "", "") ; (E5)(Download Failed)
        ; -------------------------------------------
        ZipArray := "" ; Empty This Value
        break ; [BREAK OUT] for Index, ZipFile in ZipArray
        ; -------------------------------------------
      } ; [End] else ; Zip Missing [ERROR] (E5)(Download Failed) Zip File Missing
    } ; [End] if (HadError == 0)
  } ; [End] for Index, ZipFile in ZipArray
  ; -------------------------------------------
  ; UnZip Zips
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; (Everything UnZiped) Delete Zip Files
  ; -------------------------------------------
  for Index, ZipFile in ZipArray
  {
    ; -------------------------------------------
    FileDelete, %ZipFile%
    ; -------------------------------------------
  }
  ; -------------------------------------------
  ; (Everything UnZiped) Delete Zip Files
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Dowwnload & UnZip Finished
  ; -------------------------------------------
  Sleep, 500 ; To insure Everything is Finished
  ; -------------------------------------------
  ; Dowwnload & UnZip Finished
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Create Desktop Icon
  ; -------------------------------------------
  LinkT_PopUpMenu := A_ProgramFiles "\PopUpMenu_Pum\PopUpMenu.ahk"
  LinkS_PopUpMenu := A_Desktop "\PopUpMenu.lnk"
  LinkI_PopUpMenu := A_ProgramFiles "\PopUpMenu_Pum\image\ico\PopUpMenu.ico"
  ; -------------------------------------------
  if (UserLang == "de") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Je mehr Sie es benutzen, desto mehr lieben Sie es"
    LinkD_Uninstall := "Deinstallieren Sie Popupmenu"
  }
  else if (UserLang == "en") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "The more you use it, the more you love it"
    LinkD_Uninstall := "Uninstall PopUpMenu"
  }
  else if (UserLang == "es") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Cuanto más lo usas, más te gusta"
    LinkD_Uninstall := "Desinstalar PopUpMenu"
  }
  else if (UserLang == "fr") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Plus vous l'utilisez, plus vous l'aimez"
    LinkD_Uninstall := "Désinstallez PopUpMenu"
  }
  else if (UserLang == "it") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Più lo si usa, più lo si ama"
    LinkD_Uninstall := "Disinstallare PopUpMenu"
  }
  else if (UserLang == "pl") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Im częściej go używasz, tym bardziej go kochasz"
    LinkD_Uninstall := "Odinstaluj PopUpMenu"
  }
  else if (UserLang == "pt") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Quanto mais se usa, mais se adora"
    LinkD_Uninstall := "Desinstalar PopUpMenu"
  }
  else if (UserLang == "ru") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Чем больше вы им пользуетесь, тем больше он вам нравится"
    LinkD_Uninstall := "Удалите PopUpMenu"
  }
  else if (UserLang == "sv") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Ju mer du använder den, desto mer älskar du den"
    LinkD_Uninstall := "Avinstallera PopUpMenu"
  }
  else if (UserLang == "tr") ; Link Description (LinkD_PopUpMenu) (LinkD_Uninstall)
  {
    LinkD_PopUpMenu := "Ne kadar çok kullanırsanız, o kadar çok seversiniz"
    LinkD_Uninstall := "PopUpMenu'yu kaldir"
  }
  else
  {
    LinkD_PopUpMenu := "The more you use it, the more you love it"
    LinkD_Uninstall := "Uninstall PopUpMenu"
  }
  ; -------------------------------------------
  FileCreateShortcut, %LinkT_PopUpMenu%, %LinkS_PopUpMenu%, , , %LinkD_PopUpMenu%, %LinkI_PopUpMenu%
  ; -------------------------------------------
  ; Create Desktop Icon
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  InstallComplete := 1
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Show Var_WebLink
  ; -------------------------------------------
  GuiControl, Hide, Var_ProgressBar
  GuiControl, , Var_WebLink, %Image_ProcessWeb% ; Image_ProcessWeb := A_Temp "\PopUpMenu\Process_Web.png"
  GuiControl, Show, Var_WebLink
  ; -------------------------------------------
  ; Show Var_WebLink
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Send Email New Install
  ; -------------------------------------------
  Email_Subject := "(New Install)(" InstallerNumber ")"
  Email_Body := ""
  ; -------------------------------------------
  Email_Send(Email_Subject, Email_Body, InstallerNumber)
  ; -------------------------------------------
  ; Send Email New Install
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Install Finished
  ; Desktop Shortcut Created
  ; -------------------------------------------
  FinishRun()
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
} ; [End] Label_ButtonLeft:
return
Label_CountDown: ; (CancelInstall)
{
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_CountDown
  ; global CountDownNum := 1 ; Start Frame Number
  ; global CountDownShow := 1 ; Show
  ; SetTimer, Label_CountDown, 750
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_CountDown
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_CountDown
  ; global CountDownShow := 0 ; Hide
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_CountDown
  ;
  ; -------------------------------------------
  if (CountDownShow == 1) ; [START] [ANMIMATE]
  {
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Hide All Objects
    ; -------------------------------------------
    GuiControl, Hide, Var_CountDown
    GuiControl, Hide, Var_ButtonRight
    GuiControl, Hide, Var_ButtonLeft
    GuiControl, Hide, Var_WebLink
    GuiControl, Hide, Var_ProgressBar
    ; -------------------------------------------
    ; Hide All Objects
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; -------------------------------------------
    GuiControl, , Var_CountDown, %A_Temp%\PopUpMenu\Count_%CountDownNum%.png
    GuiControl, Show, Var_CountDown
    ; -------------------------------------------
    global CountDownNum := CountDownNum - 1
    ; -------------------------------------------
    if (CountDownNum < 0)
    {
      ; -------------------------------------------
      SetTimer, Label_CountDown, Off ; (CountDown)
      ; -------------------------------------------
      if (ErrorNum != "E1" && ErrorNum != "E2" && ErrorNum != "E3" && ErrorNum != "E4" && ErrorNum != "E5" && ErrorNum != "E6")
      {
        ; -------------------------------------------
        GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_EX_%UserLang%.png
        GuiControl, Show, Var_Message
        ; -------------------------------------------
      }
      ; -------------------------------------------
      CancelInstall(ErrorNum, "Program", "", "") ; ExitApp
      ; -------------------------------------------
    } ; [End] if (CountDownNum < 0)
  } ; [End] [START] [ANMIMATE]
  else ; [STOP] [ANMIMATE]
  {
    ; -------------------------------------------
    SetTimer, Label_CountDown, Off
    GuiControl, Hide, Var_CountDown
    ; -------------------------------------------
  } ; [End] [STOP] [ANMIMATE]
  ; -------------------------------------------
} ; [End] Label_CountDown: ; (CancelInstall)
return
Label_Message:
{
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_Message
  ; global MessageNum := 1 ; Start Frame Number
  ; global MessageShow := 1 ; Show
  ; SetTimer, Label_Message, 750
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_Message
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_Message
  ; global MessageShow := 0 ; Hide
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ [ANIMATE] Var_Message
  ;
  ; -------------------------------------------
  if (MessageShow == 1) ; [START] [ANMIMATE]
  {
    ; -------------------------------------------
    if (MessageNum == 2)
    {
      SetTimer, Label_Message, 13000
    }
    else if (MessageNum == 3)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 4)
    {
      SetTimer, Label_Message, 4000
    }
    else if (MessageNum == 5)
    {
      SetTimer, Label_Message, 4000
    }
    else if (MessageNum == 6)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 7)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 8)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 9)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 10)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 11)
    {
      SetTimer, Label_Message, 2000
    }
    else if (MessageNum == 12)
    {
      SetTimer, Label_Message, 3000
    }
    else if (MessageNum == 13)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 14)
    {
      SetTimer, Label_Message, 1500
    }
    else if (MessageNum == 15)
    {
      SetTimer, Label_Message, 2000
    }
    else if (MessageNum == 16)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 17)
    {
      SetTimer, Label_Message, 17000
    }
    else if (MessageNum == 18)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 19)
    {
      SetTimer, Label_Message, 24000
    }
    else if (MessageNum == 20)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 21)
    {
      SetTimer, Label_Message, 15000
    }
    else if (MessageNum == 22)
    {
      SetTimer, Label_Message, 15000
    }
    else if (MessageNum == 23)
    {
      SetTimer, Label_Message, 15000
    }
    else if (MessageNum == 24)
    {
      SetTimer, Label_Message, 15000
    }
    else if (MessageNum == 25)
    {
      SetTimer, Label_Message, 30000
    }
    else if (MessageNum == 26)
    {
      SetTimer, Label_Message, 20000
    }
    else if (MessageNum == 27)
    {
      SetTimer, Label_Message, 20000
    }
    else if (MessageNum == 28)
    {
      SetTimer, Label_Message, 20000
    }
    else if (MessageNum == 29)
    {
      SetTimer, Label_Message, 15000
    }
    else if (MessageNum == 30)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 31)
    {
      SetTimer, Label_Message, 10000
    }
    else if (MessageNum == 32)
    {
      SetTimer, Label_Message, 20000
    }
    ; -------------------------------------------
    GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_%MessageNum%_%UserLang%.png
    GuiControl, Show, Var_Message
    ; ------------------------------------------- 321234 Total Time of Var_Message Amamation
    if (MessageNum == 32)
    {
      global MessageNum := 3
    }
    else
    {
      global MessageNum := MessageNum + 1
    }
    ; -------------------------------------------
  } ; [End] [START] [ANMIMATE]
  else ; [STOP] [ANMIMATE]
  {
    ; -------------------------------------------
    SetTimer, Label_Message, Off
    ; -------------------------------------------
  } ; [End] [STOP] [ANMIMATE]
  ; -------------------------------------------
} ; [End] Label_Message:
return
; -------------------------------------------
; [GUI] [INSTALLER] (Labels)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; END OF FILE
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

