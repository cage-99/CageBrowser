extends Panel

var index = 0

func on_cef_texture_title_changed(title: String) -> void:
	var tabs = get_tree().get_nodes_in_group("Tab")
	if index >= 0 and index < tabs.size() and is_instance_valid(tabs[index]):
		tabs[index].TabName = title
