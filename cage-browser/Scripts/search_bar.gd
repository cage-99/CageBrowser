extends Panel


func _on_line_edit_text_submitted(new_text: String) -> void:
	self.visible = false
	$LineEdit.text = ""
	var cef = $"../TabManager".GetTabTexture($"../Tabs".index)
	if new_text == "":
		return
	if cef:
		var url = new_text
		if !url.begins_with("http://") and !url.begins_with("https://"):
			url = "https://" + url
		cef.url = url
		if cef.has_method("load_url"):
			cef.load_url(url)
		cef.grab_focus()
