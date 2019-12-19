#include <FileConstants.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <Misc.au3>

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>


Global $sContentFolderPath = "../saves"
Global $sTitle = "Spamerino"
Global $hFileDic = ObjCreate("Scripting.Dictionary")
Global $bPaused = True
Global $bRunning = False
Global $aCurrentArray
Global $iCurrentIndex = 0

Global $nPlayDelay = 1500
Global $nAutoPlayDelay = 100

HotKeySet("^s", "_Save")
HotKeySet("^n", "_New")

GUISetBkColor(0x000000);GUISetBkColor(0xF0F0F0)
$hAutoSpamForm = GUICreate($sTitle, 978, 540, 259, 194)
$hMenuFile = GUICtrlCreateMenu("File")
$hMenuFileItemNew = GUICtrlCreateMenuItem("&New"&@TAB&"Ctrl+N", $hMenuFile)
$hMenuFileItemSave = GUICtrlCreateMenuItem("&Save"&@TAB&"Ctrl+S", $hMenuFile)

$hMenuControls = GUICtrlCreateMenu("Controls")
$hMenuControlsPlay = GUICtrlCreateMenuItem("Play", $hMenuControls)
$hMenuControlsPause = GUICtrlCreateMenuItem("Pause", $hMenuControls)
GUICtrlSetState($hMenuControlsPause, $GUI_DISABLE)
$hMenuControlsCancel = GUICtrlCreateMenuItem("Cancel", $hMenuControls)
GUICtrlSetState($hMenuControlsCancel, $GUI_DISABLE)

$hGroupEdit = GUICtrlCreateGroup("Edit", 24, 16, 929, 385)
$hList = GUICtrlCreateList("", 744, 40, 193, 201, BitOR($GUI_SS_DEFAULT_LIST,$LBS_DISABLENOSCROLL))
$hButtonDelete  = GUICtrlCreateButton("Delete", 864, 248, 75, 25)
$hTextarea = GUICtrlCreateEdit("", 40, 40, 681, 345, BitOR($ES_WANTRETURN,$WS_VSCROLL))
$hLabelBefore = GUICtrlCreateLabel("Before each line:", 744, 272, 84, 17)
$hInputBefore = GUICtrlCreateInput("", 744, 296, 193, 21)
$hLabelAfter = GUICtrlCreateLabel("After each line:", 744, 336, 75, 17)
$hInputAfter = GUICtrlCreateInput("", 744, 360, 193, 21)

$hGroupControls = GUICtrlCreateGroup("Controls", 24, 416, 929, 81)
$hButtonPlay = GUICtrlCreateButton("►", 40, 448, 75, 25)
GUICtrlSetFont(-1, 11)
$hButtonPause = GUICtrlCreateButton("▌ ▌", 144, 448, 75, 25)
GUICtrlSetState($hButtonPause, $GUI_DISABLE)
$hButtonCancel = GUICtrlCreateButton("█", 248, 448, 75, 25)
GUICtrlSetState($hButtonCancel, $GUI_DISABLE)
$hButtonPrevious = GUICtrlCreateButton("←", 352, 448, 75, 25)
GUICtrlSetFont(-1, 13)
GUICtrlSetState($hButtonPrevious, $GUI_DISABLE)
$hButtonNext = GUICtrlCreateButton("→", 456, 448, 75, 25)
GUICtrlSetFont(-1, 13)
GUICtrlSetState($hButtonNext, $GUI_DISABLE)
$hLabelStatus = GUICtrlCreateLabel("Status: Off.", 568, 451, 229, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)


Func _Play()
	If WinGetTitle("[ACTIVE]") <> $sTitle and $aCurrentArray <> 0 Then
		ControlSend("", "", "", "{ENTER}")
	EndIf
	sleep($nAutoPlayDelay)
	If $bRunning = True and $bPaused = False Then
		$iCurrentIndex += 1

		If $iCurrentIndex = 1 Then
			$aCurrentArray = StringSplit(GUICtrlRead($hTextarea), @CRLF, $STR_ENTIRESPLIT)
		EndIf

		If $iCurrentIndex > UBound($aCurrentArray) -1 Then
			_SuspendRun()
			Return
		EndIf

		ClipPut(GUICtrlRead($hInputBefore) & $aCurrentArray[$iCurrentIndex] & GUICtrlRead($hInputAfter))
		Send ("^v")
		_SetSkipStatus()
	EndIf
EndFunc

Func _SetPlaySettings()
	HotKeySet("{Enter}", "_Play")
	GUICtrlSetData($hLabelStatus, "Status: Running...")
	$bRunning = True
	$bPaused = False
	GUICtrlSetState($hButtonPlay, $GUI_DISABLE)
	GUICtrlSetState($hMenuControlsPlay, $GUI_DISABLE)
	GUICtrlSetState($hButtonPause, $GUI_ENABLE)
	GUICtrlSetState($hMenuControlsPause, $GUI_ENABLE)
	GUICtrlSetState($hButtonCancel, $GUI_ENABLE)
	GUICtrlSetState($hMenuControlsCancel, $GUI_ENABLE)
	GUICtrlSetState($hTextarea, $GUI_DISABLE)
	GUICtrlSetState($hList, $GUI_DISABLE)
EndFunc

Func _SetPauseSettings()
	HotKeySet("{Enter}")
	GUICtrlSetData($hLabelStatus, "Status: Paused.")
	$bPaused = True
	GUICtrlSetState($hButtonPlay, $GUI_ENABLE)
	GUICtrlSetState($hMenuControlsPlay, $GUI_ENABLE)
	GUICtrlSetState($hButtonPause, $GUI_DISABLE)
	GUICtrlSetState($hMenuControlsPause, $GUI_DISABLE)
	GUICtrlSetState($hTextarea, $GUI_ENABLE)
	GUICtrlSetState($hList, $GUI_ENABLE)
EndFunc


Func _SuspendRun()
	HotKeySet("{Enter}")
	$bRunning = False
	$iCurrentIndex = 0
	$aCurrentArray = 0
	GUICtrlSetState($hButtonPlay, $GUI_ENABLE)
	GUICtrlSetState($hMenuControlsPlay, $GUI_ENABLE)
	GUICtrlSetState($hButtonPause, $GUI_DISABLE)
	GUICtrlSetState($hMenuControlsPause, $GUI_DISABLE)
	GUICtrlSetState($hButtonCancel, $GUI_DISABLE)
	GUICtrlSetState($hMenuControlsCancel, $GUI_DISABLE)
	GUICtrlSetState($hTextarea, $GUI_ENABLE)
	GUICtrlSetState($hList, $GUI_ENABLE)
	GUICtrlSetState($hButtonPrevious, $GUI_DISABLE)
	GUICtrlSetState($hButtonNext, $GUI_DISABLE)
	GUICtrlSetData($hLabelStatus, "Status: Off.")
EndFunc


Func _Save()
	If WinGetTitle("[ACTIVE]") <> $sTitle Then
		ControlSend("", "", "", "^s")
		Return
	EndIf

	If GUICtrlRead($hList) == "" Then
		Local $sFileName = InputBox("Name", "Enter a name:", "", "", 250, 150)
		FileWrite($sContentFolderPath & "\" & $sFileName, GUICtrlRead($hTextarea))
		$hFileDic.Add($sFileName, GUICtrlRead($hTextarea))
		GUICtrlSetData($hList, $sFileName)
	Else
		$hOpenFileToSave = FileOpen($sContentFolderPath & "\" & GUICtrlRead($hList), 2)
		FileWrite($hOpenFileToSave, GUICtrlRead($hTextarea))
		FileClose($hOpenFileToSave)
		$hFileDic.Item(GUICtrlRead ($hList)) = GUICtrlRead($hTextarea)
	EndIf
EndFunc


Func _New()
	If WinGetTitle("[ACTIVE]") <> $sTitle Then
		ControlSend("", "", "", "^n")
		Return
	EndIf
	GUICtrlSetData($hTextarea, "")
	ControlCommand ($hAutoSpamForm, $sTitle, $hList, "SetCurrentSelection", "-1")
EndFunc


Func _Delete()
	If GUICtrlRead($hList) == "" Then
		Return
	EndIf
	FileDelete($sContentFolderPath & "\" & GUICtrlRead($hList))
	ControlCommand ($hAutoSpamForm, $sTitle, $hList, "DelString", ControlCommand ($hAutoSpamForm, $sTitle, $hList, "FindString", GUICtrlRead($hList)))
EndFunc


Func _LoadList()
	Local $aFileArray = _FileListToArray($sContentFolderPath)
	for $i = 1 to UBound($aFileArray) -1
		$hFileDic.Add($aFileArray[$i], FileRead($sContentFolderPath & "\" & $aFileArray[$i]))
		GUICtrlSetData($hList, $aFileArray[$i])
	Next
EndFunc


Func _SetSkipStatus()
	If $iCurrentIndex < (UBound($aCurrentArray) -2) Then
		GUICtrlSetState($hButtonNext, $GUI_ENABLE)
	Else
		GUICtrlSetState($hButtonNext, $GUI_DISABLE)
	EndIf

	If $iCurrentIndex > 0 Then
		GUICtrlSetState($hButtonPrevious, $GUI_ENABLE)
	Else
		GUICtrlSetState($hButtonPrevious, $GUI_DISABLE)
	EndIf
EndFunc

_LoadList()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hList
			GUICtrlSetData($hTextarea, $hFileDic.Item(GUICtrlRead ($hList)))
		Case $hButtonPlay
			_SetPlaySettings()
			sleep($nPlayDelay)
			_Play()
		Case $hButtonPause
			_SetPauseSettings()
		Case $hButtonCancel
			_SuspendRun()
		Case $hMenuFileItemNew
			_New()
		Case $hMenuFileItemSave
			_Save()
		Case $hButtonDelete
			_Delete()
		Case $hButtonPrevious
			$iCurrentIndex += -1
			_SetSkipStatus()
		Case $hButtonNext
			$iCurrentIndex += 1
			_SetSkipStatus()
	EndSwitch
WEnd