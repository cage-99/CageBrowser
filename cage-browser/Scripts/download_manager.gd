extends Node2D

#@onready var cef_texture: CefTexture = $"../Tabs"

#func _ready():
#	cef_texture.download_requested.connect(_on_download_requested)
#	cef_texture.download_updated.connect(_on_download_updated)

@onready var http_request = $HTTPRequest
@onready var progress_bar = $ProgressBar

var target_download_url: String = ""
var suggested_name: String = ""

var pending_downloads: Dictionary = {}

'''func _on_download_requested(info: DownloadRequestInfo):
	var cur_cef : CefTexture = get_tree().get_nodes_in_group("CefTexture")[$"../Tabs".index]
	cur_cef.stop_loading()
	# Store the download info
	pending_downloads[info.id] = info
	
	# Show confirmation dialog
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = "Download %s?\nSize: %s" % [
		info.suggested_file_name,
		_format_bytes(info.total_bytes)
	]
	dialog.confirmed.connect(_on_download_confirmed.bind(info.id))
	dialog.canceled.connect(_on_download_declined.bind(info.id))
	add_child(dialog)
	dialog.popup_centered()'''

'''func _on_download_confirmed(download_id: int):
	var info = pending_downloads.get(download_id)
	if info:
		print("User approved download: ", info.suggested_file_name)
		# NOTE: Starting downloads programmatically is not implemented yet.
		# The API to accept/start downloads is still pending.
		var cur_cef : CefTexture = get_tree().get_nodes_in_group("CefTexture")[$"../Tabs".index]
		if cur_cef.has_method("load_url"):
			cur_cef.load_url(info.url)
		cur_cef.grab_focus()
		pending_downloads.erase(download_id)'''

'''func _on_download_declined(download_id: int):
	pending_downloads.erase(download_id)
	print("User declined download")'''

'''func _on_browser_download_requested(info: DownloadRequestInfo):
	# Wir holen uns die URL und den vorgeschlagenen Namen aus dem Info-Objekt
	target_download_url = info.url
	suggested_name = info.suggested_file_name
	
	print("Download erkannt: ", suggested_name)
	
	# Jetzt öffnen Sie Ihr Godot UI-Popup (z.B. einen ConfirmationDialog)
	_zeige_abfrage_dialog()'''

'''func _on_nutzer_erlaubt_download():
	print("Starte Download über Godot HTTPRequest...")
	
	# Pfad definieren, an den Godot die Datei speichern soll
	http_request.download_file = "user://downloads/" + suggested_name
	
	# Den Request an die abgefangene URL senden
	var error = http_request.request(target_download_url)
	if error != OK:
		print("Fehler beim Starten des HTTPRequests: ", error)'''

'''func _process(_delta):
	# Den echten Fortschritt des HTTPRequests im Frame-Takt auslesen
	if http_request.get_http_client_status() == HTTPClient.STATUS_BODY:
		var geladen = http_request.get_downloaded_bytes()
		var gesamt = http_request.get_body_size()
		
		if gesamt > 0:
			var prozent = (geladen / float(gesamt)) * 100
			progress_bar.value = prozent
			print("Download-Fortschritt: %d%%" % prozent)'''

'''func _on_nutzer_bricht_ab_pressed():
	if http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		http_request.cancel_request()
		progress_bar.value = 0
		print("Download erfolgreich und sauber abgebrochen!")'''

'''func on_download_requested(info: DownloadRequestInfo):
	print("Download requested:")
	print("  File: ", info.suggested_file_name)
	print("  URL: ", info.url)
	print("  Type: ", info.mime_type)
	print("  Size: ", _format_bytes(info.total_bytes))
	
	
	# Show confirmation dialog, save to custom location, etc.
'''

'''func on_download_updated(info: DownloadUpdateInfo):
	if info.is_complete:
		print("✓ Download complete: ", info.full_path)
	elif info.is_canceled:
		print("✗ Download canceled")
	else:
		print("Downloading: %d%%" % info.percent_complete)'''

func _format_bytes(bytes: int) -> String:
	if bytes < 0:
		return "Unknown size"
	elif bytes < 1024:
		return "%d B" % bytes
	elif bytes < 1024 * 1024:
		return "%.1f KB" % (bytes / 1024.0)
	else:
		return "%.1f MB" % (bytes / (1024.0 * 1024.0))
