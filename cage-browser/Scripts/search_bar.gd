extends Panel

const WEBSITE_ENDINGS: PackedStringArray = [
	"com", "org", "net", "edu", "gov", "mil",
	"de", "at", "ch", "uk", "us", "fr", "jp",
	"io", "app", "dev", "tech", "online", "shop", "info"
]

func is_valid_extension(input_str: String) -> bool:
	var clean_ext = input_str.to_lower().strip_edges().trim_prefix(".")
	return WEBSITE_ENDINGS.has(clean_ext)

func _on_line_edit_text_submitted(new_text: String) -> void:
	self.visible = false
	$LineEdit.text = ""
	var cef = $"../TabManager".GetTabTexture($"../Tabs".index)
	if new_text == "":
		return
	if cef:
		var url = new_text
		if !url.begins_with("http://") and !url.begins_with("https://"):
			if "." in url or ":" in url and is_valid_extension(url):
				url = "https://" + url
			else:
				url = "https://www.google.com/search?q=" + url
		cef.url = url
		if cef.has_method("load_url"):
			cef.load_url(url)
		cef.grab_focus()
