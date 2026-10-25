extends Node2D

#@onready var cef_texture: CefTexture = $"../Tabs"

#func _ready():
#	cef_texture.download_requested.connect(_on_download_requested)
#	cef_texture.download_updated.connect(_on_download_updated)

func on_download_requested(info: DownloadRequestInfo):
	print("Download requested:")
	print("  File: ", info.suggested_file_name)
	print("  URL: ", info.url)
	print("  Type: ", info.mime_type)
	print("  Size: ", _format_bytes(info.total_bytes))
	
	# Show confirmation dialog, save to custom location, etc.

func on_download_updated(info: DownloadUpdateInfo):
	if info.is_complete:
		print("✓ Download complete: ", info.full_path)
	elif info.is_canceled:
		print("✗ Download canceled")
	else:
		print("Downloading: %d%%" % info.percent_complete)

func _format_bytes(bytes: int) -> String:
	if bytes < 0:
		return "Unknown size"
	elif bytes < 1024:
		return "%d B" % bytes
	elif bytes < 1024 * 1024:
		return "%.1f KB" % (bytes / 1024.0)
	else:
		return "%.1f MB" % (bytes / (1024.0 * 1024.0))
