extends Control

@onready var webview: CefTexture = $TabManager.GetTabTexture(0)
@onready var search_bar: Panel = $SearchBar
@onready var line_edit: LineEdit = $SearchBar/LineEdit

func _ready():
	if webview:
		webview.url = "https://google.com"
		webview.enable_accelerated_osr = true
		webview.set_anchors_preset(Control.PRESET_FULL_RECT)
		webview.offset_left = 114
		webview.offset_right = 0
		webview.offset_top = 0
		webview.offset_bottom = 0
		webview.mouse_filter = Control.MOUSE_FILTER_STOP
		webview.focus_mode = Control.FOCUS_ALL
