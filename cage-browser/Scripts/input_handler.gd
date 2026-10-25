extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_find_in_page"):
		$"../TabManager".FindInPage()
	elif Input.is_action_just_pressed("ui_fip_next"):
		$"../TabManager".FIPNext()
	elif Input.is_action_just_pressed("ui_fip_previous"):
		$"../TabManager".FIPPrevious()
	elif Input.is_action_just_pressed("ui_focus_url"):
		$"../SearchBar".visible = true
		
		var target_input = $"../SearchBar/LineEdit"
		target_input.set_focus_mode(Control.FOCUS_ALL)
		
		await get_tree().process_frame
		target_input.grab_focus()
	elif Input.is_action_just_pressed("ui_back"):
		$"../TabManager".UndoBack()
	elif Input.is_action_just_pressed("ui_forward"):
		$"../TabManager".RedoForward()
	elif Input.is_action_just_pressed("ui_new_tab"):
		$"../TabManager".NewTab()
	elif Input.is_action_just_pressed("ui_close_tab"):
		$"../TabManager".CloseTab()
	elif Input.is_action_just_pressed("ui_zoom_in"):
		$"../TabManager".ZoomIn()
	elif Input.is_action_just_pressed("ui_reset_zoom"):
		$"../TabManager".ResetZoom()
	elif Input.is_action_just_pressed("ui_zoom_out"):
		$"../TabManager".ZoomOut()
	elif Input.is_action_just_pressed("ui_reload"):
		$"../TabManager".ReloadTab()
	elif Input.is_action_just_pressed("ui_force_reload"):
		$"../TabManager".ForceReloadTab()
	elif Input.is_action_just_pressed("ui_switch_tab"):
		$"../TabManager".SwitchTab()
