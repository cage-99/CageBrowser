extends Control

@onready var webview: CefTexture = $TabManager.GetTabTexture(0)
@onready var search_bar: Panel = $SearchBar
@onready var line_edit: LineEdit = $SearchBar/LineEdit

func _ready():
	if webview:
		#var settings:String = ProjectSettings.globalize_path("res://HTML/settings.html")
		webview.url = "https://google.com"#"file://"+settings
		webview.enable_accelerated_osr = true
		webview.set_anchors_preset(Control.PRESET_FULL_RECT)
		webview.offset_left = 114
		webview.offset_right = 0
		webview.offset_top = 0
		webview.offset_bottom = 0
		webview.mouse_filter = Control.MOUSE_FILTER_STOP
		webview.focus_mode = Control.FOCUS_ALL
		$TabManager.ExitFullscreenEverything()


func _on_cef_texture_load_finished(url: String, http_status_code: int) -> void:
	pass # Replace with function body.
