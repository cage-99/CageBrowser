extends Node2D

######## VAR ########

@export var TabList: PackedStringArray
var tabScene : PackedScene = preload("res://Scenes/tab.tscn")
@onready var TabsParent = $"../Tabs/BoxContainer"
var CefTextureGroupName = "CefTexture"

var currentTabCount = 0

######## SET ########

func UpdateTabList():
#	print(len(TabsParent.get_children()), " vs ", len(TabList)-1)
#	if len(TabsParent.get_children()) != len(TabList)-1:
#		var missingI = CheckMissing()
#		TabsParent.get_child(missingI).queue_free()
	for i in range(currentTabCount, len(TabList)):
		var tabInstance = tabScene.instantiate()
		TabsParent.add_child(tabInstance)
		currentTabCount += 1

func CloseTab():
	TabList.remove_at($"../Tabs".index)
	
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
	
	if newCef.has_method("load_url"):
		newCef.load_url("https://google.com")
	newCef.grab_focus()
	
	UpdateTabList()
	
	#GetTab($"../Tabs".index + 1).get_child(0).get_child(1).text = "Google"
	
	$"../Tabs".index = len(TabList)-1
	
	#print("Changed ", $"../Tabs".index, " to Google")
	
	newCef.title_changed.connect($"../Tabs".on_cef_texture_title_changed) 

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
