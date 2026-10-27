extends Panel

var index = 0

func on_cef_texture_title_changed(title: String) -> void:
	var tabs = get_tree().get_nodes_in_group("Tab")
	if index >= 0 and index < tabs.size() and is_instance_valid(tabs[index]):
		tabs[index].TabName = title

func on_console_message(level: int, message: String, source: String, line: int):
	var level_names = ["DEBUG", "INFO", "WARNING", "ERROR", "FATAL"]
	var level_name = level_names[level] if level < level_names.size() else "UNKNOWN"
	print("[%s] %s (%s:%d)" % [level_name, message, source, line])
	print(" -> ", message)
	
	# Capture JavaScript errors for debugging
	if level >= 3:  # ERROR or FATAL
		push_error("JS Error: %s at %s:%d" % [message, source, line])
