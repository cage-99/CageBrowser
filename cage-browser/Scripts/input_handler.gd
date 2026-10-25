extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_url"):
		$"../SearchBar".visible = true
		
		var target_input = $"../SearchBar/LineEdit"
		target_input.set_focus_mode(Control.FOCUS_ALL)
		
		await get_tree().process_frame
		target_input.grab_focus()
	elif Input.is_action_just_pressed("ui_new_tab"):
		var CefTextureZero : CefTexture = $"../TabManager".GetTabTexture(0)
		
		CefTextureZero.browser_hidden = true
		CefTextureZero.pause_rendering_when_hidden = false
		CefTextureZero.hide()
		
		$"../TabManager".NewTab()
		#$"../TabManager".SetActiveTab(1)
	elif Input.is_action_just_pressed("ui_close_tab"):
		$"../TabManager".CloseTab()
