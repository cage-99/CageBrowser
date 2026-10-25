extends Panel

var index = 0

func on_cef_texture_title_changed(title: String) -> void:
	get_tree().get_nodes_in_group("Tab")[index].TabName = title
