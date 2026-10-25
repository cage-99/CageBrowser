extends Node2D

######## VAR ########

@export var TabList: PackedStringArray
var tabScene : PackedScene = preload("res://Scenes/tab.tscn")
@onready var TabsParent = $"../Tabs/BoxContainer"
var CefTextureGroupName = "CefTexture"

var currentTabCount = 0

######## SET ########

func UpdateTabList():
	# Sync tab UI count with TabList count (immediate, no frame delay)
	while TabsParent.get_child_count() > len(TabList):
		var child = TabsParent.get_child(TabsParent.get_child_count() - 1)
		TabsParent.remove_child(child)
		child.queue_free()
	while TabsParent.get_child_count() < len(TabList):
		TabsParent.add_child(tabScene.instantiate())
	currentTabCount = TabsParent.get_child_count()

func CloseTab():
	if len(TabList) <= 1:
		return

	var tabs_panel = $"../Tabs"
	var idx = tabs_panel.index
	if idx < 0 or idx >= len(TabList):
		idx = len(TabList) - 1

	TabList.remove_at(idx)

	# Remove the tab UI immediately (so counts are accurate right away)
	var tabs = TabsParent.get_children()
	if idx < tabs.size():
		var t = tabs[idx]
		TabsParent.remove_child(t)
		t.queue_free()

	# Remove the matching CefTexture immediately
	var cef_nodes = get_tree().get_nodes_in_group(CefTextureGroupName)
	if idx < cef_nodes.size():
		var c = cef_nodes[idx]
		if is_instance_valid(c):
			if c.get_parent() != null:
				c.get_parent().remove_child(c)
			c.queue_free()

	# Clamp index and activate previous tab
	if idx >= len(TabList):
		idx = len(TabList) - 1
	if idx < 0:
		idx = 0
	tabs_panel.index = idx

	# Show only the active CefTexture
	var cef_after = get_tree().get_nodes_in_group(CefTextureGroupName)
	for i in range(cef_after.size()):
		if is_instance_valid(cef_after[i]):
			cef_after[i].visible = (i == idx)

	UpdateTabList()

func NewTab():
	TabList.append(str(len(TabList)))
	
	var newCef = CefTexture.new()
	newCef.add_to_group(CefTextureGroupName)
	if newCef:
		newCef.url = "https://google.com"
		newCef.enable_accelerated_osr = true
		newCef.set_anchors_preset(Control.PRESET_FULL_RECT)
		newCef.offset_left = 114
		newCef.offset_right = 0
		newCef.offset_top = 0
		newCef.offset_bottom = 0
		newCef.mouse_filter = Control.MOUSE_FILTER_STOP
		newCef.focus_mode = Control.FOCUS_ALL
	$"..".add_child(newCef)

	# Show only the new tab's texture
	var cef_nodes = get_tree().get_nodes_in_group(CefTextureGroupName)
	for i in range(cef_nodes.size()):
		if is_instance_valid(cef_nodes[i]):
			cef_nodes[i].visible = (cef_nodes[i] == newCef)

	UpdateTabList()
	
	if newCef.has_method("load_url"):
		newCef.load_url("https://google.com")
	newCef.grab_focus()
	
	#GetTab($"../Tabs".index + 1).get_child(0).get_child(1).text = "Google"
	
	$"../Tabs".index = len(TabsParent.get_children())-1 #len(TabList)-1
	
	#print("Changed ", $"../Tabs".index, " to Google")
	
	newCef.title_changed.connect($"../Tabs".on_cef_texture_title_changed) 
	newCef.download_requested.connect($"../DownloadManager".on_download_requested)
	newCef.download_updated.connect($"../DownloadManager".on_download_updated)

func ReloadTab():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.reload()

func ForceReloadTab():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.reload_ignore_cache()

func UndoBack():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.go_back()

func RedoForward():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.go_forward()

func FindInPage():
	pass

func FIPNext():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.find_next()

func FIPPrevious():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.find_previous()

func ExcJS(code:String):
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.eval(code)

func ResetZoom():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.set_zoom_level(0)

func ZoomIn():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.set_zoom_level(cef.get_zoom_level()+0.1)

func ZoomOut():
	var cef : CefTexture = get_tree().get_nodes_in_group(CefTextureGroupName)[$"../Tabs".index]
	cef.set_zoom_level(cef.get_zoom_level()-0.1)

func SwitchTab():
	pass

######## GET ########

func GetTabTexture(index:int) -> Variant:
	return get_tree().get_nodes_in_group(CefTextureGroupName)[index]

func GetTab(index:int) -> Variant:
	return get_tree().get_nodes_in_group("Tab")[index]

func CheckMissing() -> int:
	for i in range(len(TabList)):
		var tab = TabList[i]
		if str(i) == tab:
			continue
		else:
			return i
	return 0

######## POST ########

func _ready() -> void:
	UpdateTabList()
