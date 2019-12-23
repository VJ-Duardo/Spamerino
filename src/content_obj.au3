Global const $CONTENT_SAVE_SIZE = 4
Global Enum $NAME, $CONTENT, $BEFORE, $AFTER

Func ContentSave($sName, $sContent, $sBefore, $sAfter)
	Local $hContentSave[$CONTENT_SAVE_SIZE]

	$hContentSave[$NAME] = $sName
	$hContentSave[$CONTENT] = $sContent
	$hContentSave[$BEFORE] = $sBefore
	$hContentSave[$AFTER] = $sAfter

	Return $hContentSave
EndFunc


Func _GetName(ByRef $hContentSave)
	Return $hContentSave[$NAME]
EndFunc

Func _SetName(ByRef $hContentSave, $sNewName)
	$hContentSave[$NAME] = $sNewName
EndFunc


Func _GetContent(ByRef $hContentSave)
	Return $hContentSave[$CONTENT]
EndFunc

Func _SetContent(ByRef $hContentSave, $sNewContent)
	$hContentSave[$CONTENT] = $sNewContent
EndFunc


Func _GetBefore(ByRef $hContentSave)
	Return $hContentSave[$BEFORE]
EndFunc

Func _SetBefore(ByRef $hContentSave, $sNewBefore)
	$hContentSave[$BEFORE] = $sNewBefore
EndFunc


Func _GetAfter(ByRef $hContentSave)
	Return $hContentSave[$AFTER]
EndFunc

Func _SetAfter(ByRef $hContentSave, $sNewAfter)
	$hContentSave[$AFTER] = $sNewAfter
EndFunc