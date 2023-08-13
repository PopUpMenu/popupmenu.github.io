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
InstallerNumber := "9c8lrpol"
ThisApp := "photoshop"
ThisLang := "en"
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ (Line 22) Installer Number and Number of Install Zip Files
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
InstallTempFolder := A_Temp "\PopUpMenu"
if !FileExist(InstallTempFolder)
{
  FileCreateDir, %InstallTempFolder%
}
; -------------------------------------------
if (A_IsAdmin == 0) ; Always Run As AdMin
{
  ; -------------------------------------------
  CheckedForAdmin := A_Temp "\PopUpMenu\CheckedForAdmin.txt"
  ; -------------------------------------------
  if !FileExist(CheckedForAdmin)
  {
    ; -------------------------------------------
    FileAppend, 1, CheckedForAdmin
    ; -------------------------------------------
    Run, *RunAs %A_ScriptFullPath%
    ; -------------------------------------------
  }
  ; -------------------------------------------
} ; Always Run As AdMin
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Vars
; -------------------------------------------
global HadError := 0
global CountDownNum := 9 ; Start Frame Number
global CountDownShow := 1 ; Show
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Functions
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
    EmailInfoArray := Email_Info()
    ;
    BoardID   := EmailInfoArray.1
    SystemName := EmailInfoArray.2
    WindowsVersion := EmailInfoArray.3
    IpPublic  := EmailInfoArray.4
    IpPrivate := EmailInfoArray.5
    HasAdminRights := EmailInfoArray.6
    ThisCity  := EmailInfoArray.7
    ThisRegion := EmailInfoArray.8
    ThisPostal := EmailInfoArray.9
    ThisCountry    := EmailInfoArray.10
    ThisContinent  := EmailInfoArray.11
    ThisCoordinates := EmailInfoArray.12
    LangPopUpMenu  := EmailInfoArray.13
    LangSystem := EmailInfoArray.14
    ContactName    := EmailInfoArray.15
    ContactEmail   := EmailInfoArray.16
    ; -------------------------------------------
    ; Email_Info()
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Email_Subject := Email_Subject " (" BoardID ")"
    ; -------------------------------------------
    PumMailFolder := "cd " A_Temp "\PopUpMenu"
    PumMailSend := "PopUpMenu_MailSend.exe"
    ; -------------------------------------------
    EmailFile := A_Temp "\PopUpMenu\EmailFile.bat"
    EmailFileLnk := A_Temp "\PopUpMenu\EmailFile.lnk"
    ; -------------------------------------------
    Email_To := "popupmenu.system@gmail.com"
    ; -------------------------------------------
    Email_From    := "popupmenu@yahoo.com"
    Email_PassWord := """yhanndksgpskbzps"""
    ; -------------------------------------------
    Email_Subject := """" Email_Subject """"
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    Line_1 := "**************************************"
    Line_2 := "BoardID        " BoardID
    Line_3 := "----------------------------------"
    Line_2 := "Installer        " ThisNumber
    Line_3 := "----------------------------------"
    Line_4 := "Entered Name       " ContactName
    Line_5 := "Entered Email        " ContactEmail
    Line_6 := "----------------------------------"
    Line_7 := "System User Name     " A_UserName
    Line_8 := "Admin Rights               " HasAdminRights
    Line_9 := "PopUpMenu Lang        " LangPopUpMenu
    Line_10 := "System Lang                " LangSystem
    Line_11 := "----------------------------------"
    Line_12 := "AutoHotKey Version    " A_AhkVersion
    Line_13 := "Windows_Version        " WindowsVersion
    Line_14 := "System Name              " SystemName
    Line_15 := "Screen DPI                  " A_ScreenDPI
    Line_16 := "Screen Width               " A_ScreenWidth
    Line_17 := "Screen Height              " A_ScreenHeight
    Line_18 := "----------------------------------"
    Line_19 := "Public IP            " IpPublic
    Line_20 := "Private IP           " IpPrivate
    Line_21 := "City                     " ThisCity
    Line_22 := "Region                " ThisRegion
    Line_23 := "Postal Code        " ThisPostal
    Line_24 := "Country               " ThisCountry
    Line_25 := "Continent             " ThisContinent
    Line_26 := "Coordinates         " ThisCoordinates
    Line_27 := "**************************************"
    ; -------------------------------------------
    ThisNum := 0
    Email_Array := ""
    Loop 27
    {
      ThisNum := ThisNum + 1
      ThisLine := Line_%ThisNum%
      Email_Array := ArrayAdd(Email_Array, ThisLine, "End") ; ThisArray, AddThis, ThisPos > ThisArray
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
      Email_Array := ArrayAdd(Email_Array, ThisLine, "End") ; ThisArray, AddThis, ThisPos > ThisArray
    }
    ; -------------------------------------------
    WriteBody := ""
    for Index, ThisLine in Email_Array
    {
      WriteBody := WriteBody " -M """ ThisLine """"
    }
    ; -------------------------------------------
    WriteLine := PumMailSend " -to " Email_To " -from " Email_From " -ssl -port 465 -auth -smtp smtp.mail.yahoo.com -sub test +cc +bc -v -user popupmenu -pass " Email_PassWord " -subject " Email_Subject WriteBody
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    FileDelete, %EmailFile%
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    FileEncoding, UTF-8 ; UTF-8
    FileAppend, `n, %EmailFile% ; UTF-8
    FileAppend, `n, %EmailFile% ; UTF-8
    FileAppend, %PumMailFolder%`n, %EmailFile% ; UTF-8
    FileAppend, %WriteLine%`n, %EmailFile% ; UTF-8
    Sleep, 250
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    FileCreateShortcut, %EmailFile%, %EmailFileLnk%
    Sleep, 500
    RunWait %EmailFileLnk% , , Hide
    Sleep, 500
    ; -------------------------------------------
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Wait until Process is NOT Running
    ; -------------------------------------------
    ThisProcess := "EmailFile.bat"
    Process, Exist, %ThisProcess%
    ; -------------------------------------------
    while (ErrorLevel != 0)
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
  } ; [End] if (HasConnection == 1)  ; Has Internet Connection
  ; -------------------------------------------
} ; [End] Email_Send(Email_Subject, Email_Body, ThisNumber)
; -------------------------------------------
Email_Info()
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Language
  ; -------------------------------------------
  LangSystem := GetLangSystem()
  LangPopUpMenu := GetLangInstall()
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
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
  ; IpPublic, IpPrivate
  ; -------------------------------------------
  File_ip := A_AppData "\PopUpMenu_PUM\temp\Get_IP.txt"
  URL_ip := "http://www.netikus.net/show_ip.html" ; (385_8)(Get IP [www.netikus.net URL Address])
  URLDownloadToFile, %URL_ip%, %File_ip% ; (385_8)(Get IP [www.netikus.net URL Address])/(380_6)(Get IP [System Text File Path])
  Sleep, 50
  ; -------------------------------------------
  FileReadLine, IpPublic, %File_ip%, 1 ; (360_7)(Public IP) / A_AppData "\PopUpMenu_PUM\temp\Get_IP.txt"
  Sleep, 100
  IpPrivate := A_IPAddress1 ; (360_8)(Private IP)
  ; -------------------------------------------
  FileDelete, %File_ip%
  ; -------------------------------------------
  ; IpPublic, IpPrivate
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; ThisCity, ThisRegion, ThisPostal, ThisCountry, ThisContinent, ThisCoordinates, 
  ; -------------------------------------------
  UrlDownloadToFile, % "https://tools.keycdn.com/geo?host=" . ip_Public, iplocate
	IPsearch := "https://tools.keycdn.com/geo?host=" . ip_Public
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", IPsearch)
	whr.Send()
	  sleep 100
	version := whr.ResponseText
	RegExMatch(version, "s)Location</p>(.*?)Time</dt>", Location)
    FileRead, version2, iplocate
	RegExMatch(version, "Coordinates</dt><dd class=""col-8 text-monospace"">(.*?) \(lat\) / (.*?)\(long\)", Map)
	Map := Map1 . "," . Map2
	MapLink := "<a href=""https://www.openstreetmap.org/?mlat=" . map1 . "&mlon=" . map2 . "#map=5/" . Map . "&layers=C"">Go to larger map" . "</a>"
	Location := RegExReplace(Location1,"<.+?>")
  ; -------------------------------------------
  Location := "@" Location
  Location := StrReplace(Location, "`n", "")
  Location := StrReplace(Location, "  ", "")
  Location := StrReplace(Location, "City", "")
  Location := StrReplace(Location, "Region", "@")
  Location := StrReplace(Location, "Postal code", "@")
  Location := StrReplace(Location, "Country", "@")
  Location := StrReplace(Location, "Continent", "@")
  Location := StrReplace(Location, "Coordinates", "@")
  ; -------------------------------------------
  Pos_1 := InStr(Location, "@", , , 1)
  Pos_2 := InStr(Location, "@", , , 2)
  Pos_3 := InStr(Location, "@", , , 3)
  Pos_4 := InStr(Location, "@", , , 4)
  Pos_5 := InStr(Location, "@", , , 5)
  Pos_6 := InStr(Location, "@", , , 6)
  ; -------------------------------------------
  Len_1 := Pos_2 - 2
  Len_2 := Pos_3 - Pos_2
  Len_3 := Pos_4 - Pos_3
  Len_4 := Pos_5 - Pos_4
  Len_5 := Pos_6 - Pos_5
  ; -------------------------------------------
  ThisCity  := SubStr(Location, 2, Len_1)
  ThisRegion := SubStr(Location, Pos_2 + 1, Len_2 - 1)
  ThisPostal := SubStr(Location, Pos_3 + 1, Len_3 - 1)
  ThisCountry    := SubStr(Location, Pos_4 + 1, Len_4 - 1)
  ThisContinent  := SubStr(Location, Pos_5 + 1, Len_5 - 1)
  ThisCoordinates := SubStr(Location, Pos_6 + 1)
  ; -------------------------------------------
  ; ThisCity, ThisRegion, ThisPostal, ThisCountry, ThisContinent, ThisCoordinates, 
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
  File_HasAdminRights := A_AppData "\PopUpMenu_PUM\system\File_HasAdminRights.txt"
  ; -------------------------------------------
  if FileExist(File_HasAdminRights)
  {
    FileReadLine, HasAdminRights, %File_HasAdminRights%, 1
  }
  else
  {
    HasAdminRights := "File_HasAdminRights.txt Not Found"
  }
  ; -------------------------------------------
  ; HasAdminRights
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
  FileDelete, %A_ScriptDir%\iplocate
  FileDelete, %A_Desktop%\iplocate
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ReturnArray := []
  ReturnArray[1] := BoardID
  ReturnArray[2] := SystemName
  ReturnArray[3] := WindowsVersion
  ReturnArray[4] := IpPublic
  ReturnArray[5] := IpPrivate
  ReturnArray[6] := HasAdminRights
  ReturnArray[7] := ThisCity
  ReturnArray[8] := ThisRegion
  ReturnArray[9] := ThisPostal
  ReturnArray[10] := ThisCountry
  ReturnArray[11] := ThisContinent
  ReturnArray[12] := ThisCoordinates
  ReturnArray[13] := LangPopUpMenu
  ReturnArray[14] := LangSystem
  ReturnArray[15] := ContactName
  ReturnArray[16] := ContactEmail
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; [(1)BoardID , (2)SystemName, (3)WindowsVersion, (4)IpPublic, (5)IpPrivate, (6)HasAdminRights, (7)ScreenSize, (8)ScreenDPI, (9)ThisCity, (10)ThisRegion, (11)ThisPostal, (12)ThisCountry, (13)ThisContinent, (14)ThisCoordinates, (15)LangPopUpMenu, (16)LangSystem]
  return ReturnArray
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  /*
    EmailInfoArray := Email_Info()
    
    BoardID   := EmailInfoArray.1
    SystemName := EmailInfoArray.2
    WindowsVersion := EmailInfoArray.3
    IpPublic  := EmailInfoArray.4
    IpPrivate := EmailInfoArray.5
    HasAdminRights := EmailInfoArray.6
    ThisCity  := EmailInfoArray.7
    ThisRegion := EmailInfoArray.8
    ThisPostal := EmailInfoArray.9
    ThisCountry    := EmailInfoArray.10
    ThisContinent  := EmailInfoArray.11
    ThisCoordinates := EmailInfoArray.12
    LangPopUpMenu  := EmailInfoArray.13
    LangSystem := EmailInfoArray.14
    ContactName    := EmailInfoArray.15
    ContactEmail   := EmailInfoArray.16
  */
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
} ; [End] Email_Info()
; -------------------------------------------
Install_ConnectCheck(flag=0x40) ; > [0/1]
{
  return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}
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
DoUnZip(ZipFile)
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; UnZip to A_Temp NO Admin Rights Needed
  ; -------------------------------------------
  UnZipDir := A_Temp "\PopUpMenu"
  Move_F := A_Temp "\PopUpMenu\PopUpMenu_PUM"
  Move_T := A_ProgramFiles "\PopUpMenu_PUM"
  ; -------------------------------------------
  psh := ComObjCreate("Shell.Application")
  psh.Namespace( UnZipDir ).CopyHere( psh.Namespace( ZipFile ).items, 4|16 )
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Write Script to Move to A_ProgramFiles "\PopUpMenu_PUM"
  ; then Run, *RunAs ThatScript
  ; -------------------------------------------  
  PluginMover := A_Temp "\PopUpMenu\PluginMover.ahk"
  Line_01 := "`#NoEnv"
  Line_02 := "`#NoTrayIcon"
  Line_03 := "FileMove, `%A_Temp`%\PopUpMenu\PopUpMenu_PUM, `%A_ProgramFiles`%\PopUpMenu_PUM"
  Line_04 := "ExitApp"
  ; -------------------------------------------
  FileEncoding, UTF-8 ; UTF-8
  FileAppend, %Line_01%`n, %PluginMover% ; UTF-8
  FileAppend, %Line_02%`n, %PluginMover% ; UTF-8
  FileAppend, %Line_03%`n, %PluginMover% ; UTF-8
  FileAppend, %Line_04%`n, %PluginMover% ; UTF-8
  Sleep, 500
  Run, *RunAs %PluginMover%
  ; -------------------------------------------
}
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
   ; -------------------------------------------
  } ; [End] if (ErrorNum == "EX") ; User Pressed Canceled
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ExitApp
  ; -------------------------------------------
} ; [End] CancelInstall(ErrorNum, ThisType, ThisApp, ThisLang) ; CancelInstall(["E1-E6"/"EX"], ["Program"/"Plugin"], ThisApp, ThisLang) ; > ExitApp
; -------------------------------------------
;
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
} ; [End] HttpQueryInfo(URL, QueryInfoFlag=21, Proxy="", ProxyBypass="")
; -------------------------------------------
GetPercent(GetPercentArray) ; > ThisPercent
{
  ; -------------------------------------------
  ; (ThisType == "UnZip")  [ThisType, UnZipPath, ThisTotal]
  ; (ThisType == "File")   [ThisType, ThisFile, ThisTotal]
  ; (ThisType == "Number") [ThisType, [[FileSize, FilePath], [FileSize, FilePath], etc], ThisTotal]
  ; -------------------------------------------
  ThisType := GetPercentArray.1
  ; -------------------------------------------
  ;
  if (ThisType == "UnZip")
  {
    ; -------------------------------------------
    UnZipPath := GetPercentArray.2 ; A_Temp "\PopUpMenu\PopUpMenu_PUM"
    ThisTotal := GetPercentArray.3
    ; -------------------------------------------
    SizeNow := 0
    ; -------------------------------------------
    Loop, Files, %UnZipPath%\*.*, R
    {
      ; -------------------------------------------
      ThisFile := A_LoopFileFullPath
      FileGetSize, ThisSize, %ThisFile%
      ; -------------------------------------------
      SizeNow := SizeNow + (ThisSize * 0.25)
      ; -------------------------------------------
    }
    ; -------------------------------------------
  }
  ; -------------------------------------------
  else if (ThisType == "File")
  {
    ; -------------------------------------------
    ThisFile := GetPercentArray.2
    ThisTotal := GetPercentArray.3
    ; -------------------------------------------
    FileGetSize, SizeNow, %ThisFile%
    ; -------------------------------------------
    if (SizeNow == "")
    {
      SizeNow := 0
    }
  }
  ; -------------------------------------------
  ;
  ; -------------------------------------------
  ThisPercent := (SizeNow / ThisTotal) * 100
  ; -------------------------------------------
  return ThisPercent
  ; -------------------------------------------
} ; [End] GetPercentArray(FileArray, SizeTotal) ; > ThisPercent
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
;
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
; Functions
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [FIRST] Check it There is a Internet Connection
; -------------------------------------------
UserLang := GetLangInstall() ; > UserLang
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
; [FIRST] Check it There is a Internet Connection
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [OK] (Internet)
; [DOWNLOAD] (domain_installer.txt)
; -------------------------------------------
else ; [OK] (Internet)
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; [FOLDER] [CREATE] for Installer file and Images
  ; -------------------------------------------
  InstallFolder := A_Temp "\PopUpMenu"
  ; -------------------------------------------
  if !FileExist(InstallFolder) ; Folder Does Not Exist, Create Folder
  {
    FileCreateDir, %InstallFolder%
  }
  else ; Folder Does Exist, Delete everything in the Folder
  {
    Filedelete, %InstallFolder%\*.*
  }
  ; -------------------------------------------
  ; [FOLDER] [CREATE] for Installer file and Images
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; [DOWNLOAD] domain_installer.txt
  ; -------------------------------------------
  Url_DomainInstaller := "https://midnightitsalmost.github.io/system/domain_installer.txt"
  Txt_DomainInstaller := A_Temp "\PopUpMenu\domain_installer.txt"
  Downloaded_OK := DownloadFile(Url_DomainInstaller, Txt_DomainInstaller)
  ; -------------------------------------------
  ; [DOWNLOAD] domain_installer.txt
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
} ; [End] [OK] (Internet)
; -------------------------------------------
if (Downloaded_OK == 0) ; [ERROR] (M2)(MsgBox)(Download Failed) domain_installer.txt
{
  ; -------------------------------------------
  if (UserLang == "de")
  {
    MsgBox, 262192, Systemfehler, (M2) Installer fehlgeschlagen, 5
  }
  else if (UserLang == "en")
  {
    MsgBox, 262192, System Error, (M2) Installer Failed, 5
  }
  else if (UserLang == "es")
  {
    MsgBox, 262192, Error del sistema, (M2) Instalador falló, 5
  }
  else if (UserLang == "fr")
  {
    MsgBox, 262192, Erreur système, (M2) L'installateur a échoué, 5
  }
  else if (UserLang == "it")
  {
    MsgBox, 262192, Errore di sistema, (M2) Installer non riuscito, 5
  }
  else if (UserLang == "pl")
  {
    MsgBox, 262192, Blad systemu, (M2) Instalator nie powiódl sie, 5
  }
  else if (UserLang == "pt")
  {
    MsgBox, 262192, Erro no sistema, (M2) Instalador falhou, 5
  }
  else if (UserLang == "ru")
  {
    MsgBox, 262192, Системная ошибка, (M2) Сбой установщика, 5
  }
  else if (UserLang == "sv")
  {
    MsgBox, 262192, Systemfel, (M2) Installer misslyckades, 5
  }
  else if (UserLang == "tr")
  {
    MsgBox, 262192, Sistem hatasi, (M2) Yükleyici basarisiz oldu, 5
  }
  else
  {
    MsgBox, 262192, System Error, (M2) Installer Failed, 5
  }
  ; -------------------------------------------
  FileRemoveDir, %A_Temp%\PopUpMenu, 1
  ExitApp ; (MsgBox)(Download Failed) domain_installer.txt
  ; -------------------------------------------
} ; [End] if (Downloaded_OK == 0) ; [ERROR] (MsgBox)(Download Failed) domain_installer.txt
; -------------------------------------------
; [OK] (Internet)
; [DOWNLOAD] (domain_installer.txt)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; (Download Support Files)
; -------------------------------------------
FileReadLine, DomainInstaller, %Txt_DomainInstaller%, 1
; -------------------------------------------
Url_1 := DomainInstaller "/install/installer_common.zip"
Url_2 := DomainInstaller "/install/installer_common_" ThisLang ".zip"
Url_3 := DomainInstaller "/install/installer_appplugin_" ThisApp "_" ThisLang ".zip"
ArrayUrl := [Url_1, Url_2, Url_3, Url_4]
; -------------------------------------------
File_1 := A_Temp "\PopUpMenu\installer_common.zip"
File_2 := A_Temp "\PopUpMenu\installer_common_" ThisLang ".zip"
File_3 := A_Temp "\PopUpMenu\installer_appplugin_" ThisApp "_" ThisLang ".zip"
ArrayFile := [File_1, File_2, File_3]
; -------------------------------------------
InstallTempFolder := A_Temp "\PopUpMenu"
if !FileExist(InstallTempFolder)
{
  FileCreateDir, %InstallTempFolder%
} ; [End] if !FileExist(CheckFolder)
for index, ThisFile in ArrayFile
{
  if FileExist(ThisFile)
  {
    FileDelete, %ThisFile%
  } ; [End] if FileExist(ThisFile)
} ; [End] for index, ThisFile in ArrayFile
; -------------------------------------------
DownloadSupportProcessBar(ArrayUrl, ArrayFile)
; -------------------------------------------
;
; -------------------------------------------
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
;
; -------------------------------------------
; Check (Downloaded Support Files) Exist
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
; (Download Support Files)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [CHECK]/[UNZIP] (Download Support Files)
; -------------------------------------------
if (HadError == 1) ; (M3)There Was a Error
{
  ; -------------------------------------------
  HadError := 1
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
{ ; [SET] [VARS] FilePaths [Plugin]
  ; -------------------------------------------
  ArrayFileCheck := ""
  ; -------------------------------------------
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_appplugin_" ThisApp "_" ThisLang ".zip"
  Image_Message_1 := A_Temp "\PopUpMenu\Message_1_" ThisLang ".png" ; (This Will Install) [Plugin]/[PopUpMenu]
  Image_Message_2 := A_Temp "\PopUpMenu\Message_2_" ThisLang ".png" ; ([Plugin] Downloading)/([Program] Please be patient)
  Image_Message_3 := A_Temp "\PopUpMenu\Message_3_" ThisLang ".png" ; ([Plugin] Decompress)/([Program] Please be patient)
  Image_Message_4 := A_Temp "\PopUpMenu\Message_4_" ThisLang ".png" ; ([Plugin] Installing)/([Program] Please be patient)
  Image_Message_5 := A_Temp "\PopUpMenu\Message_5_" ThisLang ".png" ; ([Plugin] Installation Completed)/([Program] Please be patient)
  Image_Error_E2 := A_Temp "\PopUpMenu\Message_E2_" ThisLang ".png" ; [ERROR] (E2 Already Installed)
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_appplugin_" ThisApp "_" ThisLang ".zip"  
  ;
  ;
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common_" ThisLang ".zip"
  Image_Button_Yes := A_Temp "\PopUpMenu\ButtonLeft_Yes_" ThisLang ".png"
  Image_Button_Cancel := A_Temp "\PopUpMenu\ButtonRight_Cancel_" ThisLang ".png"
  Image_Button_Finish := A_Temp "\PopUpMenu\ButtonRight_Finish_" ThisLang ".png"
  Image_Button_No := A_Temp "\PopUpMenu\ButtonRight_No_" ThisLang ".png"
  ; -------------------------------------------
  Image_Message_0 := A_Temp "\PopUpMenu\Message_0_" ThisLang ".png" ; (Loading PopUpMenu)
  ; -------------------------------------------
  Image_Error_E1 := A_Temp "\PopUpMenu\Message_E1_" ThisLang ".png" ; (E1 Install Failed)
  Image_Error_E3 := A_Temp "\PopUpMenu\Message_E3_" ThisLang ".png" ; (E3 No Internet Connection)
  Image_Error_E4 := A_Temp "\PopUpMenu\Message_E4_" ThisLang ".png" ; (E4 No Admin Rights)
  Image_Error_E5 := A_Temp "\PopUpMenu\Message_E5_" ThisLang ".png" ; (E5)(Download Failed)
  Image_Error_E6 := A_Temp "\PopUpMenu\Message_E6_" ThisLang ".png" ; (E6 Installer Expired)
  Image_Error_E7 := A_Temp "\PopUpMenu\Message_E7_" ThisLang ".png" ; (E7)(PopUpMenu Not Installed)
  Image_Error_EX := A_Temp "\PopUpMenu\Message_EX_" ThisLang ".png" ; (E6 Installer Expired)
  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "installer_common_" ThisLang ".zip"
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
} ; [SET] [VARS] FilePaths [Plugin]
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
  ErrorNum := ErrorGUI(UserLang, "E4", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (E4)(NO Admin Rights)
  ; -------------------------------------------
}
; -------------------------------------------
; [CHECK] (Admin Rights)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if (HadError == 0) ; (OK) (Admin Rights)
{
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
  ; [CHECK] (E7)(PopUpMenu Not Installed)
  ; -------------------------------------------
  InstalledPopUpMenuFolder := A_ProgramFiles "\PopUpMenu_PUM"
  if !FileExist(InstalledPopUpMenuFolder)
  {
    ; ------------------------------------------- [Plugin]
    HadError := 1
    ; ------------------------------------------- [Plugin]
    ErrorNum := ErrorGUI(UserLang, "E7", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (E7)(PopUpMenu Not Installed)
    ; ------------------------------------------- [Plugin]
  }
  else ; PopUpMenu is Installed
  {
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
    ; [CHECK] (E2 Already Installed), if 1 ; [ERROR] (E2 Already Installed)
    ; -------------------------------------------
    InstalledPluginFolder := A_ProgramFiles "\PopUpMenu_PUM\menu\mnu\" ThisApp "\" ThisLang
    ; ------------------------------------------- [Plugin]
    if FileExist(InstalledPluginFolder) ; [ERROR] (E2 Already Installed)
    {
      ; ------------------------------------------- [Plugin]
      HadError := 1
      ; ------------------------------------------- [Plugin]
      ErrorNum := ErrorGUI(UserLang, "E2", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (E2)(Already Installed)
      ; ------------------------------------------- [Plugin]
    } ; [End] if FileExist(InstalledPluginFolder) ; [ERROR] (E2 Already Installed)
    ; ------------------------------------------- [Plugin]
    ; [CHECK] (E2 Already Installed), if 1 (E2 Already Installed) 
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
    ;
    if (HadError == 0) ; (OK) (NOT) (Already Installed)
    {
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
      ; [DOWNLOAD] (domain_installaddon.txt) Domain for Install (Plugin Zip)
      ; ------------------------------------------- [Plugin]
      Url_DomainInstall := "https://midnightitsalmost.github.io/system/domain_installaddon.txt"
      File_DomainZipInstall := A_Temp "\PopUpMenu\domain_installaddon.txt"
      Downloaded_OK := DownloadFile(Url_DomainInstall, File_DomainZipInstall)
      ; ------------------------------------------- [Plugin]
      ; [DOWNLOAD] (domain_installaddon.txt) Domain for Install (Plugin Zip)
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
      ;
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
      ; [CHECK] (Downloaded_OK) (domain_installaddon.txt), if 0 (E5)(Download Failed)
      ; ------------------------------------------- [Plugin]
      if (Downloaded_OK == 0) ; (domain_installaddon.txt) Was NOT Downloaded
      {
        ; ------------------------------------------- [Plugin]
        HadError := 1
        ; ------------------------------------------- [Plugin]
        ErrorNum := ErrorGUI(UserLang, "E5", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (E5)(Download Failed)
        ; -------------------------------------------
      } ; [End] if (Downloaded_OK == 0) ; (domain_installaddon.txt) Was NOT Downloaded
      ; ------------------------------------------- [Plugin]
      ; [CHECK] (Downloaded_OK) (domain_installaddon.txt), if 0 (E5)(Download Failed)
      ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
      ;
      if (HadError == 0) ; (OK) (Download Failed)
      {
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
        ; [DOWNLOAD] (PopUpMenu_InstallerNumber.txt)
        ; [CHECK] (Installer Date), if NOT Exist (PopUpMenu_InstallerNumber.txt) (E6)(Installer Expired)
        ; ------------------------------------------- [Plugin]
        FileReadLine, DomainInstallZips, %File_DomainZipInstall%, 1
        Sleep, 100
        ; ------------------------------------------- [Plugin]
        Url_InstallerNumber := DomainInstallZips "/installzips/" ThisApp "_" ThisLang "_" InstallerNumber ".txt" ; InstallerNumber on Line 22
        File_InstallerNumber := A_Temp "\PopUpMenu\" ThisApp "_" ThisLang "_" InstallerNumber ".txt" ; InstallerNumber on Line 22
        Downloaded_OK := DownloadFile(Url_InstallerNumber, File_InstallerNumber)
        Sleep, 500
        ; ------------------------------------------- [Plugin]
        if (Downloaded_OK == 0 or !FileExist(File_InstallerNumber))
        {
          ; ------------------------------------------- [Plugin]
          HadError := 1
          ; ------------------------------------------- [Plugin]
          ErrorNum := ErrorGUI(UserLang, "E6", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (E6)(Installer Expired)
          ; ------------------------------------------- [Plugin]
        }
        ; ------------------------------------------- [Plugin]
        ; [DOWNLOAD] (PopUpMenu_InstallerNumber.txt)
        ; [CHECK] (Installer Date), if NOT Exist (PopUpMenu_InstallerNumber.txt) (E6)(Installer Expired)
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
        ;
        if (HadError == 0) ; (OK) (NOT) (Installer Expired)
        {
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
          ; (Everything OK) (Ask to Install)
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [Plugin]
          ;
          ; ------------------------------------------- [Plugin]
          GuiControl, Hide, Var_CountDown
          ; ------------------------------------------- [Plugin]
          GuiControl, , Var_ButtonLeft, %Image_Button_Yes% ; Image_Button_Yes := A_Temp "\PopUpMenu\ButtonLeft_Yes_" ThisLang ".png"
          GuiControl, Show, Var_ButtonLeft
          ; ------------------------------------------- [Plugin]
          ImageButtonRight := "No"
          GuiControl, , Var_ButtonRight, %Image_Button_No% ; Image_Button_No := A_Temp "\PopUpMenu\ButtonRight_No_" ThisLang ".png"
          GuiControl, Show, Var_ButtonRight
          ; ------------------------------------------- [Plugin]
          GuiControl, , Var_Message, %Image_Message_1% ; (This Will Install) [Plugin]/[PopUpMenu]
          GuiControl, Show, Var_Message
          ; ------------------------------------------- [Plugin]
          return ; return Here to End the Gui
          ; ------------------------------------------- [Plugin]
          ;
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          ; (Everything OK) (Ask to Install)
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        } ; [End] if (HadError == 0) ; (OK) (NOT) (Installer Expired)
      } ; [End] if (HadError == 0) ; (OK) (Download Failed)
    } ; [End] if (HadError == 0) ; (OK) (E2 Already Installed)
  } ; [End] else ; PopUpMenu is Installed
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
    CancelInstall("", "Plugin", ThisApp, ThisLang) ; (User Said No)
    ; -------------------------------------------
  } ; [End] if (ImageButtonRight == "No") ; [Common]
  ; -------------------------------------------
  else if (ImageButtonRight == "Cancel") ; [Plugin]
  {
    ; -------------------------------------------
    WinGet, Gui_Id, ID , ahk_class AutoHotkeyGUI
    WinSet, AlwaysOnTop, Off, ahk_id %Gui_Id%
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    HadError := 1
    ; -------------------------------------------
    ErrorNum := ErrorGUI(UserLang, "EX", InstallerNumber, "Plugin", ThisApp, ThisLang) ; (EX)(User Pressed Cancel)
    ; -------------------------------------------
  } ; [End] else if (ImageButtonRight == "Cancel") ; [ Plugin]
  ; -------------------------------------------
  else if (ImageButtonRight == "Finish") ; ("Finish") (ExitApp)
  {
    ; -------------------------------------------
    Gui, Destroy
    ; -------------------------------------------
    TempFiles := A_Temp "\PopUpMenu\*.*"
    FileDelete, %TempFiles%
    ; -------------------------------------------
    TempFolder := A_Temp "\PopUpMenu"
    FileRemoveDir, %TempFolder%, 1 ; Delete A_Temp "\PopUpMenu"
    Sleep, 500
    ; -------------------------------------------
    ExitApp
    ; -------------------------------------------
  }
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
  GuiControl, , Var_Message, %Image_Message_2%  ; (Downloading)
  GuiControl, Show, Var_Message,
  ; -------------------------------------------
  ImageButtonRight := "Cancel"
  GuiControl, , Var_ButtonRight, %Image_Button_Cancel% ; Image_Button_Cancel := A_Temp "\PopUpMenu\ButtonRight_Cancel_" ThisLang ".png"
  GuiControl, Show, Var_ButtonRight
  ; -------------------------------------------
  ; Show objects
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Download Zip (ThisApp_Thislang_InstallerNumber.zip) (Part 1)
  ; -------------------------------------------
  ZipArray := []
  ZipNum := 0
  ; -------------------------------------------
  ZipUrl := DomainInstallZips "/installzips/" ThisApp "_" ThisLang "_" InstallerNumber ".zip"
  ZipFile := A_Temp "\PopUpMenu\" ThisApp "_" ThisLang "_" InstallerNumber ".zip"
  ; -------------------------------------------
  ThisTotalUrlSize := HttpQueryInfo(ZipUrl, 5)
  ; -------------------------------------------
  ; Download Zip (ThisApp_Thislang_InstallerNumber.zip) (Part 1)
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Progress Bar
  ; -------------------------------------------
  PluginPercentArray := ["File", ZipFile, ThisTotalUrlSize] ; (ThisType == "File") [ThisType, ThisFile, ThisTotal]
  SetTimer, Label_ProgressBar, 50
  ; -------------------------------------------
  ; Progress Bar
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>        
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Download Zip (ThisApp_Thislang_InstallerNumber.zip) (Part 2)
  ; -------------------------------------------
  Downloaded_OK := DownloadFile(ZipUrl, ZipFile) ; Download (PopUpMenu_ZipNum_InstallerNumber.zip)
  ; -------------------------------------------
  ; Download Zip (ThisApp_Thislang_InstallerNumber.zip) (Part 2)
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ;
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; UnZip Zip (ThisApp_Thislang_InstallerNumber.zip)
  ; -------------------------------------------
  if (Downloaded_OK == 1)
  {
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Progress Bar
    ; -------------------------------------------
    SetTimer, Label_ProgressBar, Off
    ; -------------------------------------------
    ; Progress Bar
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GuiControl, Show, Var_ProgressBar
    ; Show objects
    ; -------------------------------------------
    GuiControl, , Var_Message, %Image_Message_3%  ; (Decomress)
    GuiControl, Show, Var_Message,
    ; -------------------------------------------
    ; Show objects
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Progress Bar
    ; -------------------------------------------
    UnZipPath := A_Temp "\PopUpMenu\PopUpMenu_PUM"
    FileGetSize, ThisTotalZipSize, %ZipFile%
    PluginPercentArray := ["UnZip", UnZipPath, ThisTotalZipSize] ; (ThisType == "UnZip")  [ThisType, UnZipPath, ThisTotal]
    SetTimer, Label_ProgressBar, 50
    ; -------------------------------------------
    ; Progress Bar
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>        
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; UnZip to A_Temp NO Admin Rights Needed
    ; -------------------------------------------
    UnZipDir := A_Temp "\PopUpMenu"
    ; -------------------------------------------
    psh := ComObjCreate("Shell.Application")
    psh.Namespace( UnZipDir ).CopyHere( psh.Namespace( ZipFile ).items, 4|16 )
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    Sleep, 500
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Progress Bar
    ; -------------------------------------------
    SetTimer, Label_ProgressBar, Off
    ; -------------------------------------------
    ; Progress Bar
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GuiControl, Show, Var_ProgressBar
    ; Show objects
    ; -------------------------------------------
    GuiControl, , Var_Message, %Image_Message_4%  ; (Installing)
    GuiControl, Show, Var_Message,
    ; -------------------------------------------
    ; Show objects
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Write Script to Move to A_ProgramFiles "\PopUpMenu_PUM"
    ; -------------------------------------------  
    PluginMover := A_Temp "\PopUpMenu\PluginMover.ahk"
    ; -------------------------------------------
    if FileExist(PluginMover)
    {
      FileDelete, %PluginMover%
    }
    ; -------------------------------------------
    Line_01 := "`#NoEnv"
    Line_02 := "`#NoTrayIcon"
    Line_03 := "Loop`, Files`, `%A_Temp`%\PopUpMenu\PopUpMenu_PUM\*.*`, R"
    Line_04 := "`{"
    Line_05 := "File_F `:`= A_LoopFileFullPath"
    Line_06 := "File_T `:`= StrReplace(File_F`, A_Temp ""\PopUpMenu\PopUpMenu_PUM""`, A_ProgramFiles ""\PopUpMenu_PUM"")"
    Line_07 := "SplitPath`, File_T`, `, OutDir"
    Line_08 := "if `!FileExist(OutDir)"
    Line_09 := "`{"
    Line_10 := "FileCreateDir`, `%OutDir`%"
    Line_11 := "Sleep`, 100"
    Line_12 := "`}"
    Line_13 := "FileMove`, `%File_F`%`, `%File_T`%"
    Line_14 := "`}"
    Line_15 := "ExitApp"
    FileEncoding, UTF-8 ; UTF-8
    FileAppend, %Line_01%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_02%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_03%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_04%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_05%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_06%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_07%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_08%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_09%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_10%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_11%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_12%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_13%`n, %PluginMover% ; UTF-8
    FileAppend, %Line_14%`n, %PluginMover% ; UTF-8
    Sleep, 500
    ; -------------------------------------------
    ; Write Script to Move to A_ProgramFiles "\PopUpMenu_PUM"
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Progress Bar
    ; -------------------------------------------
    ThisPercent := 0
    PluginPercentArray := ["Number", "", ""] ; (ThisType == "Number") [ThisType, [[FileSize, FilePath], [FileSize, FilePath], etc], ThisTotal]
    SetTimer, Label_ProgressBar, 100
    ; -------------------------------------------
    ; Progress Bar
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Move Files
    ; -------------------------------------------
    SourcePattern := A_Temp "\PopUpMenu\PopUpMenu_PUM\menu\*.*"
    DestinationFolder := A_ProgramFiles "\PopUpMenu_PUM\menu"
    ; -------------------------------------------
    FileMove, %SourcePattern%, %DestinationFolder%, 1
	  Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
	  {
  		FileMoveDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, 1
  	}
    ; -------------------------------------------
    ; Move Files
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;
    Sleep, 500 ; Give time to complete Process
    ;
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Install Finished
    ; -------------------------------------------
    Email_Body := ""
    Email_Subject := "(Plugin Install) " ThisApp "_" ThisLang "_" InstallerNumber
    ;
    Email_Send(Email_Subject, Email_Body, InstallerNumber)
    ; -------------------------------------------
    ;
    ; -------------------------------------------
    GuiControl, , Var_Message, %Image_Message_5%  ; (Installation Complete)
    GuiControl, Show, Var_Message,
    ; -------------------------------------------
    SetTimer, Label_ProgressBar, Off
    GuiControl, Hide, Var_ProgressBar
    GuiControl, , Var_WebLink, %Image_ProcessWeb% ; Image_ProcessWeb := A_Temp "\PopUpMenu\Process_Web.png"
    GuiControl, Show, Var_WebLink
    ; -------------------------------------------
    ImageButtonRight := "Finish"
    GuiControl, , Var_ButtonRight, %Image_Button_Finish% ; Image_Button_Finish := A_Temp "\PopUpMenu\ButtonRight_Finish_" ThisLang ".png"
    GuiControl, Show, Var_ButtonRight
    ; -------------------------------------------
    ; Install Finished
    ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  } ; [End] if (Downloaded_OK == 1)
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
        GuiControl, , Var_Message, %A_Temp%\PopUpMenu\Message_EX_%ThisLang%.png
        GuiControl, Show, Var_Message
        ; -------------------------------------------
      }
      else if (ErrorNum != "E7") ; (E7)(PopUpMenu Not Installed)
      {
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; Check if There ia a Internet Connection
        ; -------------------------------------------
        flag=0x40
        HasConnection := DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
        ; -------------------------------------------
        ; Check if There ia a Internet Connection
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        if (HasConnection == 1) ; Internet Connection OK
        {
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          ; Get Current PopUpMenu Web Site
          ; -------------------------------------------
          File_PopupmenuSiteDomain := A_ProgramFiles "\PopUpMenu_PUM\update\domain_popupmenusite.txt"
          if FileExist(File_PopupmenuSiteDomain)
          {
            FileReadLine, PopupmenuSiteDomain, %File_PopupmenuSiteDomain%, 1
          } ; [End] if FileExist(File_PopupmenuSiteDomain)
          ; -------------------------------------------
          ; Get Current PopUpMenu Web Site
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          ;
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          if (PopupmenuSiteDomain != "") ; (PopupmenuSiteDomain) is NOT Empty
          {
            ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ; Open Current PopUpMenu Web Site
            ; -------------------------------------------
            PopUpMenuWebSite := PopupmenuSiteDomain "/"
            Run, %PopUpMenuWebSite%,,, Priority_PopUpMenuWebSite
            Process, Priority, %Priority_PopUpMenuWebSite%, High
            ; -------------------------------------------
            ; Open Current PopUpMenu Web Site
            ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          }
          ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        } ; [End] if (HasConnection == 1) ; Internet Connection OK
        ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      }
      ; -------------------------------------------
      CancelInstall(ErrorNum, "Plugin", ThisApp, ThisLang) ; > ExitApp
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
}
return
; -------------------------------------------
; [GUI] [INSTALLER] (Labels)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; END OF FILE
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
