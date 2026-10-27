extends Panel

var index = 0
var markedElementsName: PackedStringArray
var markedElementsClass: PackedStringArray
@export var style_ohne_rand : StyleBox
@export var style_mit_rand : StyleBox
var rand_status_aktuell : bool = false

var _oldIndex = 1

func on_cef_texture_title_changed(title: String) -> void:
	$"../TabManager".ExcJS('document.head.innerHTML+="<style>* { border-radius:0px !important; }</style>"')
	$"../TabManager".ExcJS('''(function(){if(window.trustedTypes&&!window.trustedTypes.defaultPolicy){window.trustedTypes.createPolicy('default',{createHTML:s=>s,createScript:s=>s,createScriptURL:s=>s})}var s=document.createElement('script');s.textContent='// Policy aktiv';document.body.appendChild(s);})();
''')
	var tabs = get_tree().get_nodes_in_group("Tab")
	if index >= 0 and index < tabs.size() and is_instance_valid(tabs[index]):
		tabs[index].TabName = title

func on_console_message(level: int, message: String, source: String, line: int):
	var level_names = ["DEBUG", "INFO", "WARNING", "ERROR", "FATAL"]
	var level_name = level_names[level] if level < level_names.size() else "UNKNOWN"
	print("[%s] %s (%s:%d)" % [level_name, message, source, line])
	print(" -> ", message)
	
	if message.begins_with("Marked:"):
		var splited = message.split("'")
		markedElementsName.append(splited[1])
		markedElementsClass.append(splited[2])
		print("Added Mark Name: " + splited[1])
		print("Added Mark Class: " + splited[2])
	
	# Capture JavaScript errors for debugging
	if level >= 3:  # ERROR or FATAL
		push_error("JS Error: %s at %s:%d" % [message, source, line])
func aktualisiere_alle_tabs(soll_rand_zeigen: bool) -> void:
	var atabs = $BoxContainer.get_children()
	
	for tabParent in atabs:
		var gewaehlter_style = style_mit_rand if soll_rand_zeigen else style_ohne_rand
		var tab = tabParent.get_child(0)
		# SICHERHEITS-CHECK: Wir überschreiben BEIDE gängigen Typen, 
		# egal ob es ein Button oder ein Panel ist!
		if tab.has_method("add_theme_stylebox_override"):
			tab.add_theme_stylebox_override("panel", gewaehlter_style)  # Für Panels
			tab.add_theme_stylebox_override("normal", gewaehlter_style) # Für Buttons

func aktualisiere_tabs(i, soll_rand_zeigen: bool) -> void:
	var atabs = $BoxContainer.get_children()
	var gewaehlter_style = style_mit_rand if soll_rand_zeigen else style_ohne_rand
	var tab = atabs[i].get_child(0)
	# SICHERHEITS-CHECK: Wir überschreiben BEIDE gängigen Typen, 
	# egal ob es ein Button oder ein Panel ist!
	if tab.has_method("add_theme_stylebox_override"):
		tab.add_theme_stylebox_override("panel", gewaehlter_style)  # Für Panels
		tab.add_theme_stylebox_override("normal", gewaehlter_style) # Für Buttons

func _process(delta: float) -> void:
	if _oldIndex != index:
		aktualisiere_alle_tabs(false)
		aktualisiere_tabs($".".index, true)
		_oldIndex = index
#	var atabs = $BoxContainer.get_children()
#	for tab in atabs:
#		print("Change to with")
#		zeige_rand(true, tab)

##### HELPER FUNCTIONS #####

func clearMarks():
	markedElementsClass.clear()
	markedElementsName.clear()


func on_cef_texture_load_finished(url: String, http_status_code: int) -> void:
	$"../TabManager".ExcJS('document.head.innerHTML+="<style>* { border-radius:0px !important; }</style>"')
