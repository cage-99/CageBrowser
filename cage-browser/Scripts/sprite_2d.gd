extends Sprite2D

# 1. PASSE DIESEN PFAD AN: Zeigt auf deinen CEF-Browser Node
@onready var cef_node = $"../CefTexture" 

var http_request : HTTPRequest

func _ready() -> void:
	# Erstellt den Downloader automatisch im Hintergrund
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_favicon_downloaded)
	
	# Verbindet das Signal, sobald eine neue Seite in CEF geladen wurde
	# Falls dein CEF-Addon das Signal anders nennt (z.B. "url_changed"), passe es hier an
	#if cef_node.has_signal("page_loaded"):
	#	cef_node.page_loaded.connect(_on_page_loaded)
	#else:
	#	push_warning("Signal 'page_loaded' nicht gefunden. Stelle sicher, dass das CEF-Signal stimmt.")

# Wird aufgerufen, wenn CEF eine neue Seite geladen hat
'''func on_page_loaded(url: String, http_status_code: int) -> void:
	var aktuelle_url = url
	if aktuelle_url.is_empty(): return
	
	# Säubert die URL, um die reine Domain zu erhalten (z.B. google.com)
	var domain = aktuelle_url.replacen("https://", "").replacen("http://", "")
	if "/" in domain:
		domain = domain.split("/")[0]
	
	# LÖSUNG: Wir nutzen die Google-Schnittstelle.
	# Diese erzwingt ein PNG-Format (sz=32 oder sz=64 für die Pixel-Größe)
	var api_url = "https://google.com/" + domain.split(".")[1] + "." + domain.split(".")[2] + "/&sz=64"
	
	print("Lade konvertiertes PNG über Google-API: ", api_url)
	
	var error = http_request.request(api_url)
	if error != OK:
		push_error("Fehler beim Starten des Favicon-Downloads.")'''

func on_page_start_loading(url: String) -> void:
	self.visible = false
	var aktuelle_url = url
	if aktuelle_url.is_empty(): return
	
	var domain = aktuelle_url.replacen("https://", "").replacen("http://", "")
	if "/" in domain:
		domain = domain.split("/")[0]
	
	var api_url = "https://getfavicon.dev/" + domain + "/high"
	print("Lade Favicon über API: ", api_url)
	
	var error = http_request.request(api_url)
	if error != OK:
		push_error("Fehler beim Starten des Favicon-Downloads.")

func on_page_loaded(url: String, http_status_code: int) -> void:
	#self.visible = true
	var aktuelle_url = url
	get_tree().get_first_node_in_group("EventManager").load_url_with_adblock("")
	if aktuelle_url.is_empty(): return
	
	var domain = aktuelle_url.replacen("https://", "").replacen("http://", "")
	if "/" in domain:
		domain = domain.split("/")[0]
	
	var api_url = "https://getfavicon.dev/" + domain + "/high"
	print("Lade Favicon über API: ", api_url)
	
	var error = http_request.request(api_url)
	if error != OK:
		push_error("Fehler beim Starten des Favicon-Downloads.")

func _on_favicon_downloaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200 or body.size() < 6:
		push_error("Download fehlgeschlagen oder Datei leer.")
		return

	var image = Image.new()
	
	# 1. Prüfen, ob es direkt ein normales Bild (PNG/WebP/JPG) ist
	if image.load_png_from_buffer(body) == OK or image.load_webp_from_buffer(body) == OK or image.load_jpg_from_buffer(body) == OK:
		_apply_texture(image)
		return

	# 2. Es ist eine .ico-Datei -> Wir konvertieren sie manuell zu einem Image
	# ICO Header-Check (Bytes 0-3 müssen 0, 0, 1, 0 sein)
	if body[0] == 0 and body[1] == 0 and body[2] == 1 and body[3] == 0:
		var img_count = body[4] | (body[5] << 8)
		if img_count == 0: return
		
		# Wir lesen den ersten Eintrag im Verzeichnis (ab Byte 6, Länge 16 Bytes)
		var width = body[6]
		var height = body[7]
		if width == 0: width = 256 # 0 steht im ICO-Format oft für 256px
		if height == 0: height = 256
		
		# Daten-Größe und Daten-Offset auslesen
		var data_size = body[14] | (body[15] << 8) | (body[16] << 16) | (body[17] << 24)
		var data_offset = body[18] | (body[19] << 8) | (body[20] << 16) | (body[21] << 24)
		
		var icon_data = body.slice(data_offset, data_offset + data_size)
		
		# Check, ob innerhalb der ICO an dieser Stelle ein PNG versteckt ist
		if icon_data.size() >= 4 and icon_data[0] == 137 and icon_data[1] == 80 and icon_data[2] == 78 and icon_data[3] == 71:
			if image.load_png_from_buffer(icon_data) == OK:
				_apply_texture(image)
				return

		# Wenn kein PNG, ist es eine unkomprimierte 32-Bit BGRA BMP
		# Die Pixeldaten starten nach dem Bitmap Header (40 Bytes)
		var bmp_header_size = 40
		if icon_data.size() > bmp_header_size:
			var pixel_data_offset = bmp_header_size
			var raw_pixels = PackedByteArray()
			raw_pixels.resize(width * height * 4)
			
			# ICO-Bitmaps sind von unten nach oben (flipped) und im BGRA-Format gespeichert
			# Wir konvertieren sie in das von Godot lesbare RGBA-Format
			for y in range(height):
				var target_y = (height - 1) - y
				var source_row_offset = pixel_data_offset + (y * width * 4)
				var target_row_offset = target_y * width * 4
				
				if source_row_offset + (width * 4) <= icon_data.size():
					for x in range(width):
						var px = x * 4
						var b = icon_data[source_row_offset + px + 0]
						var g = icon_data[source_row_offset + px + 1]
						var r = icon_data[source_row_offset + px + 2]
						var a = icon_data[source_row_offset + px + 3]
						
						var t_px = target_row_offset + px
						raw_pixels[t_px + 0] = r
						raw_pixels[t_px + 1] = g
						raw_pixels[t_px + 2] = b
						raw_pixels[t_px + 3] = a
			
			# Erstelle das fertige Godot-Bild direkt aus den konvertierten Bytes!
			image = Image.create_from_data(width, height, false, Image.FORMAT_RGBA8, raw_pixels)
			_apply_texture(image)
			return

	push_error("ICO-Konvertierung fehlgeschlagen: Dateiformat nicht unterstützt.")

# Die absolute Zielgröße für alle Icons im Spiel (in Pixeln)
const ZIEL_GROESSE = Vector2i(16, 16)

func _apply_texture(img: Image) -> void:
	# 1. Unsichtbare Ränder der Originaldatei wegschneiden
	var echtes_logo_rechteck = img.get_used_rect()
	if echtes_logo_rechteck.size.x > 0 and echtes_logo_rechteck.size.y > 0:
		img = img.get_region(echtes_logo_rechteck)
	
	# 2. Seitenverhältnis beibehalten und die optimale Skalierung berechnen
	var orig_w = img.get_width()
	var orig_h = img.get_height()
	
	var scale_factor = min(float(ZIEL_GROESSE.x) / orig_w, float(ZIEL_GROESSE.y) / orig_h)
	
	var neue_breite = max(1, int(orig_w * scale_factor))
	var neue_hoehe = max(1, int(orig_h * scale_factor))
	
	# Das Logo proportional skalieren, damit nichts verzerrt
	img.resize(neue_breite, neue_hoehe, Image.INTERPOLATE_LANCZOS)
	
	# 3. Das "Genormte Quadrat" erschaffen: Ein leeres, transparentes Bild (32x32)
	var final_canvas = Image.create_empty(ZIEL_GROESSE.x, ZIEL_GROESSE.y, false, Image.FORMAT_RGBA8)
	
	# Die exakte Mitte berechnen, um das Logo perfekt zu zentrieren
	var cent_x = (ZIEL_GROESSE.x - neue_breite) / 2
	var cent_y = (ZIEL_GROESSE.y - neue_hoehe) / 2
	
	# Das proportionale Logo zentriert auf das transparente Quadrat draufstempeln
	final_canvas.blit_rect(img, Rect2i(0, 0, neue_breite, neue_hoehe), Vector2i(cent_x, cent_y))
	
	# 4. Textur erstellen und zuweisen
	var neue_textur = ImageTexture.create_from_image(final_canvas)
	self.texture = neue_textur
	
	# WICHTIG: Setze die Skalierung des Sprite2D-Nodes zurück auf 1!
	# Die Größe wird jetzt direkt über die Pixelanzahl des Bildes bestimmt.
	self.scale = Vector2.ONE
	
	self.visible = true
	print("Favicon vollautomatisch zentriert auf exakt ", ZIEL_GROESSE.x, "x", ZIEL_GROESSE.y, " Pixel normiert!")
