#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>

#include <GUIListBox.au3>
#include <GuiEdit.au3>

#include "content_obj.au3"


Global $sTitle = "Spamerino"
Global $hCSObjDic = ObjCreate("Scripting.Dictionary")
Global $bPaused = True
Global $bRunning = False
Global $aCurrentArray
Global $iCurrentIndex = 0

Global $nPlayDelay = 1500
Global $nAutoPlayDelay = 100

HotKeySet("^s", "_Save")
HotKeySet("^n", "_New")
HotKeySet("^!p", "_SetPlaySettings")

GUISetBkColor(0x000000)
$hAutoSpamForm = GUICreate($sTitle, 978, 672, 259, 194)
;Menu bar
$hMenuFile = GUICtrlCreateMenu("File")
$hMenuFileItemNew = GUICtrlCreateMenuItem("&New"&@TAB&"Ctrl+N", $hMenuFile)
$hMenuFileItemSave = GUICtrlCreateMenuItem("&Save"&@TAB&"Ctrl+S", $hMenuFile)

$hMenuControls = GUICtrlCreateMenu("Controls")
$hMenuControlsPlay = GUICtrlCreateMenuItem("Play"&@TAB&"Ctrl+Alt+P", $hMenuControls)
$hMenuControlsPause = GUICtrlCreateMenuItem("Pause"&@TAB&"Ctrl+Alt+P", $hMenuControls)
GUICtrlSetState($hMenuControlsPause, $GUI_DISABLE)
$hMenuControlsCancel = GUICtrlCreateMenuItem("Cancel"&@TAB&"Ctrl+Alt+C", $hMenuControls)
GUICtrlSetState($hMenuControlsCancel, $GUI_DISABLE)
$hMenuControlsPrevious = GUICtrlCreateMenuItem("Previous"&@TAB&"Ctrl+Alt+←", $hMenuControls)
GUICtrlSetState($hMenuControlsPrevious, $GUI_DISABLE)
$hMenuControlsNext = GUICtrlCreateMenuItem("Next"&@TAB&"Ctrl+Alt+→", $hMenuControls)
GUICtrlSetState($hMenuControlsNext, $GUI_DISABLE)

;Edit group
$hGroupEdit = GUICtrlCreateGroup("Edit", 24, 16, 929, 385)
$hList = GUICtrlCreateList("", 744, 40, 193, 201, BitOR($GUI_SS_DEFAULT_LIST,$LBS_DISABLENOSCROLL))
$hButtonDelete  = GUICtrlCreateButton("Delete", 864, 248, 75, 25)
$hTextarea = GUICtrlCreateEdit("", 40, 40, 681, 345, BitOR($ES_WANTRETURN,$WS_VSCROLL))
_GUICtrlEdit_SetLimitText($hTextarea, 1000000)
$hLabelBefore = GUICtrlCreateLabel("Before each line:", 744, 272, 84, 17)
$hInputBefore = GUICtrlCreateInput("", 744, 296, 193, 21)
$hLabelAfter = GUICtrlCreateLabel("After each line:", 744, 336, 75, 17)
$hInputAfter = GUICtrlCreateInput("", 744, 360, 193, 21)

;Status group
$hGroupStatus = GUICtrlCreateGroup("Status", 24, 416, 929, 121)
$hLabelCurrLine = GUICtrlCreateLabel("Current line: ", 40, 480, 80, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$hLabelNextLine = GUICtrlCreateLabel("Next line: ", 40, 504, 65, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$hLabelNextLineText = GUICtrlCreateLabel("-", 128, 504, 808, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$hLabelCurrLineText = GUICtrlCreateLabel("-", 128, 480, 808, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$hLabelLiveDot = GUICtrlCreateLabel("•", 56, 432, 13, 36)
GUICtrlSetFont(-1, 20, 400, 0, "Arial")
GUICtrlSetColor(-1, 0x000000)
$hLabelState = GUICtrlCreateLabel("State: Off.", 81, 441, 230, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

;Control group
$hGroupControls = GUICtrlCreateGroup("Controls", 24, 552, 929, 81)
$hButtonPlay = GUICtrlCreateButton("►", 40, 584, 75, 25)
GUICtrlSetFont(-1, 11)
$hButtonPause = GUICtrlCreateButton("▌ ▌", 144, 584, 75, 25)
GUICtrlSetState($hButtonPause, $GUI_DISABLE)
$hButtonCancel = GUICtrlCreateButton("█", 248, 584, 75, 25)
GUICtrlSetState($hButtonCancel, $GUI_DISABLE)
$hButtonPrevious = GUICtrlCreateButton("←", 352, 584, 75, 25)
GUICtrlSetFont(-1, 13)
GUICtrlSetState($hButtonPrevious, $GUI_DISABLE)
$hButtonNext = GUICtrlCreateButton("→", 456, 584, 75, 25)
GUICtrlSetFont(-1, 13)
GUICtrlSetState($hButtonNext, $GUI_DISABLE)
GUISetState(@SW_SHOW)



;Start of the Program

$iStartPID = Run("utils/json_content.exe read", "", @SW_HIDE, 2)
ProcessWaitClose($iStartPID)
$aJsonData = StringSplit(StdoutRead($iStartPID), " , ", $STR_ENTIRESPLIT)
If UBound($aJsonData) <> 0 and Mod($aJsonData[0], 4) == 0 Then
	_LoadList($aJsonData)
EndIf



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
		_SetLineStatus(True)
		_SetSkipStatus(0)
	EndIf
EndFunc


Func _SetPlaySettings()
	If GUICtrlRead($hTextarea) == "" Then
		_SuspendRun()
		Return
	EndIf
	HotKeySet("{Enter}", "_Play")
	HotKeySet("^!p", "_SetPauseSettings")
	HotKeySet("^!c", "_SuspendRun")
	HotKeySet("^!{LEFT}", "_SetSkipStatusFromHotkey")
	HotKeySet("^!{RIGHT}", "_SetSkipStatusFromHotkey")
	GUICtrlSetData($hLabelState, "State: Running...")
	GUICtrlSetColor($hLabelLiveDot, 0x00FF00)
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
	sleep($nPlayDelay)
	_Play()
EndFunc

Func _SetPauseSettings()
	HotKeySet("{Enter}")
	HotKeySet("^!p", "_SetPlaySettings")
	GUICtrlSetData($hLabelState, "State: Paused.")
	GUICtrlSetColor($hLabelLiveDot, 0xFF0000)
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
	HotKeySet("^!p", "_SetPlaySettings")
	HotKeySet("^!c")
	HotKeySet("^!{LEFT}")
	HotKeySet("^!{RIGHT}")
	GUICtrlSetData($hLabelState, "State: Off.")
	GUICtrlSetData($hLabelCurrLineText, "-")
	GUICtrlSetData($hLabelNextLineText, "-")
	GUICtrlSetColor($hLabelLiveDot, 0x000000)
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
	GUICtrlSetState($hMenuControlsPrevious, $GUI_DISABLE)
	GUICtrlSetState($hMenuControlsNext, $GUI_DISABLE)
EndFunc


Func _Save()
	If WinGetTitle("[ACTIVE]") <> $sTitle Then
		ControlSend("", "", "", "^s")
		Return
	EndIf

	If GUICtrlRead($hList) == "" Then
		$bNameCorrect = False
		$sPrompt = "Enter a name:"
		While Not $bNameCorrect
			Local $sNewEntryName = InputBox("Name", $sPrompt, "", "", 250, 150)
			If @error == 1 Then
				Return
			EndIf

			If $sNewEntryName == "" or $hCSObjDic.Exists($sNewEntryName) Then
				If $sNewEntryName == "" Then
					$sPrompt = "The name cant be empty." & @CRLF & "Enter a name:"
				Else
					$sPrompt = "This name already exists." & @CRLF & "Enter a name:"
				EndIf
			Else
				$bNameCorrect = True
			EndIf
		WEnd

		$hNewCSObj = ContentSave($sNewEntryName, GUICtrlRead($hTextarea), GUICtrlRead($hInputBefore), GUICtrlRead($hInputAfter))
		If _SendDataToJson($hNewCSObj, "utils/json_content.exe new") Then
			$hCSObjDic.Add($sNewEntryName, $hNewCSObj)
			GUICtrlSetData($hList, $sNewEntryName)
			ControlCommand ($hAutoSpamForm, $sTitle, $hList, "SelectString", $sNewEntryName)
		EndIf
	Else
		$hCSObj = $hCSObjDic.Item(GUICtrlRead ($hList))
		_SetContent($hCSObj, GUICtrlRead($hTextarea))
		_SetBefore($hCSObj, GUICtrlRead($hInputBefore))
		_SetAfter($hCSObj, GUICtrlRead($hInputAfter))
		If _SendDataToJson($hCSObj, "utils/json_content.exe save") Then
			$hCSObjDic.Item(GUICtrlRead ($hList)) = $hCSObj
		EndIf
	EndIf
EndFunc


Func _New()
	If WinGetTitle("[ACTIVE]") <> $sTitle Then
		ControlSend("", "", "", "^n")
		Return
	EndIf
	GUICtrlSetData($hTextarea, "")
	GUICtrlSetData($hInputBefore, "")
	GUICtrlSetData($hInputAfter, "")
	ControlCommand ($hAutoSpamForm, $sTitle, $hList, "SetCurrentSelection", "-1")
EndFunc


Func _Delete()
	If GUICtrlRead($hList) == "" Then
		Return
	EndIf

	Local $aDelName[1] = [GUICtrlRead($hList)]
	If _SendDataToJson($aDelName, "utils/json_content.exe delete") Then
		$hCSObjDic.Remove(GUICtrlRead($hList))
		ControlCommand ($hAutoSpamForm, $sTitle, $hList, "DelString", ControlCommand ($hAutoSpamForm, $sTitle, $hList, "FindString", GUICtrlRead($hList)))
		GUICtrlSetData($hTextarea, "")
		GUICtrlSetData($hInputBefore, "")
		GUICtrlSetData($hInputAfter, "")
	EndIf
EndFunc


Func _SendDataToJson($aDataArgs, $sProgPath)
	$sDataStr = ""
	For $i = 0 To UBound($aDataArgs)-1 Step 1
		If $i == UBound($aDataArgs)-1 Then
			$sDataStr = $sDataStr & StringReplace($aDataArgs[$i], ",", "/,")
		Else
			$sDataStr = $sDataStr & StringReplace($aDataArgs[$i], ",", "/,") & " , "
		EndIf
	Next
	$iPid = Run($sProgPath, "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
	StdinWrite($iPid, StringToBinary($sDataStr, 4))
	StdinWrite($iPid)
	ProcessWaitClose($iPid)
	If StdoutRead($iPid) == "Success" Then
		Return True
	EndIf
EndFunc


Func _LoadList($aJsonData)
	For $i = 1 To $aJsonData[0] Step 4
		For $j=0 To 4-1 Step 1
			$aJsonData[$i+$j] = StringReplace(BinaryToString(StringToBinary($aJsonData[$i+$j]), 4), "/,", ",")
		Next
		$hNewContentSaveObj = ContentSave($aJsonData[$i], $aJsonData[$i+1], $aJsonData[$i+2], $aJsonData[$i+3])
		$hCSObjDic.Add($aJsonData[$i], $hNewContentSaveObj)
		GUICtrlSetData($hList, $aJsonData[$i])
	Next
EndFunc


Func _SetLineStatus($bChangeCurrent)
	If $bChangeCurrent Then
		GUICtrlSetData($hLabelCurrLineText, $aCurrentArray[$iCurrentIndex])
	EndIf

	If $iCurrentIndex < (UBound($aCurrentArray))-1 Then
		GUICtrlSetData($hLabelNextLineText, $aCurrentArray[$iCurrentIndex+1])
	Else
		GUICtrlSetData($hLabelNextLineText, "-")
	EndIf
EndFunc

Func _SetSkipStatusFromHotkey()
	switch @HotKeyPressed
		Case "^!{LEFT}"
			_SetSkipStatus(-1)
		Case "^!{RIGHT}"
			_SetSkipStatus(1)
	EndSwitch
EndFunc

Func _SetSkipStatus($nIndexChange)
	$iCurrentIndex += $nIndexChange
	If $iCurrentIndex < (UBound($aCurrentArray) -2) Then
		GUICtrlSetState($hButtonNext, $GUI_ENABLE)
		GUICtrlSetState($hMenuControlsNext, $GUI_ENABLE)
		HotKeySet("^!{RIGHT}", "_SetSkipStatusFromHotkey")
	Else
		GUICtrlSetState($hButtonNext, $GUI_DISABLE)
		GUICtrlSetState($hMenuControlsNext, $GUI_DISABLE)
		HotKeySet("^!{RIGHT}")
	EndIf

	If $iCurrentIndex > 0 Then
		GUICtrlSetState($hButtonPrevious, $GUI_ENABLE)
		GUICtrlSetState($hMenuControlsPrevious, $GUI_ENABLE)
		HotKeySet("^!{LEFT}", "_SetSkipStatusFromHotkey")
	Else
		GUICtrlSetState($hButtonPrevious, $GUI_DISABLE)
		GUICtrlSetState($hMenuControlsPrevious, $GUI_DISABLE)
		HotKeySet("^!{LEFT}")
	EndIf
	_SetLineStatus(False)
EndFunc


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hList
			If GUICtrlRead ($hList) <> "" Then
				$hCSObj = $hCSObjDic.Item(GUICtrlRead ($hList))
				GUICtrlSetData($hTextarea, _GetContent($hCSObj))
				GUICtrlSetData($hInputBefore, _GetBefore($hCSObj))
				GUICtrlSetData($hInputAfter, _GetAfter($hCSObj))
			EndIf
		Case $hButtonPlay
			_SetPlaySettings()
		Case $hMenuControlsPlay
			_SetPlaySettings()
		Case $hButtonPause
			_SetPauseSettings()
		Case $hMenuControlsPause
			_SetPauseSettings()
		Case $hButtonCancel
			_SuspendRun()
		Case $hMenuControlsCancel
			_SuspendRun()
		Case $hButtonPrevious
			_SetSkipStatus(-1)
		Case $hMenuControlsPrevious
			_SetSkipStatus(-1)
		Case $hButtonNext
			_SetSkipStatus(1)
		Case $hMenuControlsNext
			_SetSkipStatus(1)
		Case $hMenuFileItemNew
			_New()
		Case $hMenuFileItemSave
			_Save()
		Case $hButtonDelete
			_Delete()
	EndSwitch
WEnd