extends Panel

var index = 0
var markedElementsName: PackedStringArray
var markedElementsClass: PackedStringArray
@export var style_ohne_rand : StyleBox
@export var style_mit_rand : StyleBox
var rand_status_aktuell : bool = false
var ad_blacklist: Dictionary = {}

var _oldIndex = 1

func on_cef_texture_title_changed(title: String) -> void:
	#$"../TabManager".ExcJS('document.head.innerHTML+="<style>* { border-radius:0px !important; }</style>"')
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

func on_browser_resource_request(url: String) -> int:
	# URL in Kleinbuchstaben umwandeln, um Groß-/Kleinschreibung zu ignorieren
	var lower_url = url.to_lower()
	
	# Überprüfen, ob eine der blockierten Domains in der URL vorkommt
	# Dank der Dictionary-Struktur verbraucht das kaum Performance
	for ad_domain in ad_blacklist:
		if ad_domain in lower_url:
			print("[AdBlock] Blockierte Werbe-Ressource: ", url)
			return 1 # 1 = Cancel/Block (CEF bricht das Laden dieses Elements ab)
			
	return 0 # 0 = Allow (Erlaube das Laden des Elements)

func on_autofill_button_pressed():
	var entry_title = get_tree().get_nodes_in_group("CefTexture")[index].url.split("/")[2]
	
	var output = []
	var bash_args = [
		"-c",
		"kpxc-cli show " + entry_title + " -p"
	]
	var exit_code = OS.execute("bash", bash_args, output, true)
	if exit_code == 0 and output.size() > 0:
		var password
		var username
		var totp
		for line in str(output[0]).split("\n"):
			if "Password:" in line:
				password = line.replace(" ", "").split("Password:")[1]
			if "Username:" in line:
				username = line.replace(" ", "").split("Username:")[1]
			if "TOTP:" in line:
				totp = line.replace(" ", "").split("TOTP:")[1]
		_inject_credentials(username, password, totp)
	else:
		print("KeePassXC-CLI Fehler oder Eintrag nicht gefunden.")

func _ready() -> void:
	#$"../CefTexture".request
	_load_easylist("res://AdBlock/easylist.txt")

##### HELPER FUNCTIONS #####

func _inject_credentials(user: String, passw: String, totp_code: String):
	# 1. Alle Credentials in GDScript sicher in Base64 umwandeln
	var user_b64 = Marshalls.utf8_to_base64(user)
	var passw_b64 = Marshalls.utf8_to_base64(passw)
	var totp_b64 = Marshalls.utf8_to_base64(totp_code)

	# 2. Das erweiterte JavaScript (inklusive fT für TOTP/Zwei-Faktor-Eingaben)
	var js_code = "(function(){function fP(r){r=r||document;let p=r.querySelector('input[type=\"password\"]');if(p)return p;let a=r.querySelectorAll('*');for(let el of a){if(el.shadowRoot){let f=fP(el.shadowRoot);if(f)return f;}}return null;}function fU(r){r=r||document;let f=r.querySelector('input[type=\"email\"],input[autocomplete=\"username\"],input[name=\"username\"],input[name=\"login\"]');if(f)return f;let t=r.querySelectorAll('input[type=\"text\"]');for(let i of t){let n=i.getAttribute('name')||'';let p=i.getAttribute('placeholder')||'';if(n!=='q'&&!p.toLowerCase().includes('search'))return i;}let a=r.querySelectorAll('*');for(let el of a){if(el.shadowRoot){let f=fU(el.shadowRoot);if(f)return f;}}return null;}function fT(r){r=r||document;let t=r.querySelector('input[type=\"tel\"],input[autocomplete=\"one-time-code\"],input[name=\"totp\"],input[name=\"code\"]');if(t)return t;let a=r.querySelectorAll('*');for(let el of a){if(el.shadowRoot){let f=fT(el.shadowRoot);if(f)return f;}}return null;}function sV(i,v){if(!i)return;i.focus();i.value=decodeURIComponent(escape(atob(v)));i.dispatchEvent(new Event('input',{bubbles:true,cancelable:true}));i.dispatchEvent(new Event('change',{bubbles:true,cancelable:true}));i.blur();}let u=fU();let p=fP();let t=fT();if(u){sV(u,\"{username_b64}\");}if(p){sV(p,\"{password_b64}\");}if(t){sV(t,\"{totp_b64}\");}})();"

	# Einsetzen der Base64-Strings via Godots Format-Funktion
	var formatted_js = js_code.format({
		"username_b64": user_b64,
		"password_b64": passw_b64,
		"totp_b64": totp_b64
	})
	
	$"../TabManager".ExcJS(formatted_js)


'''func _inject_credentials(user: String, passw: String):
	var js_code = """
(function() {
	function findPasswordInShadow(root) {
		root = root || document;
		let pwd = root.querySelector('input[type="password"]');
		if (pwd) return pwd;

		let allElements = root.querySelectorAll('*');
		for (let el of allElements) {
			if (el.shadowRoot) {
				let found = findPasswordInShadow(el.shadowRoot);
				if (found) return found;
			}
		}
		return null;
	}

	function findUsernameInShadow(root) {
		root = root || document;
		const selector = 'input[type="email"], input[autocomplete="username"], input[name="username"], input[name="login"]';
		
		let found = root.querySelector(selector);
		if (found) return found;

		let textInputs = root.querySelectorAll('input[type="text"]');
		for (let input of textInputs) {
			let name = input.getAttribute('name') || '';
			let placeholder = input.getAttribute('placeholder') || '';
			if (name !== 'q' && !placeholder.toLowerCase().includes('search')) {
				return input;
			}
		}

		let allElements = root.querySelectorAll('*');
		for (let el of allElements) {
			if (el.shadowRoot) {
				let foundInShadow = findUsernameInShadow(el.shadowRoot);
				if (foundInShadow) return foundInShadow;
			}
		}
		return null;
	}

	function setInputValue(inputElement, value) {
		if (!inputElement) return;
		inputElement.focus();
		inputElement.value = value;

		var inputEvent = new Event('input', { bubbles: true, cancelable: true });
		inputElement.dispatchEvent(inputEvent);

		var changeEvent = new Event('change', { bubbles: true, cancelable: true });
		inputElement.dispatchEvent(changeEvent);

		inputElement.blur();
	}

	var u = findUsernameInShadow();
	var p = findPasswordInShadow();
	if (u) { setInputValue(u, "{username}"); }
	if (p) { setInputValue(p, "{password}"); }
})();
"""

	# Sicheres Ersetzen der Daten über ein Dictionary ohne den %-Operator
	var formatted_js = js_code.format({
		"username": user,
		"password": passw
	})
	
	$"../TabManager".ExcJS(formatted_js)
'''

func load_url_with_adblock(url: String):
	#$CefBrowser.load_url(url)
	# Kurze Verzögerung oder nach dem Laden ausführen
	$CefBrowser.execute_javascript(get_adblock_js_code())

func get_adblock_js_code() -> String:
	var file = FileAccess.open("res://AdBlock/easylist.txt", FileAccess.READ)
	var domains = []
	
	while not file.get_position() >= file.get_length():
		var line = file.get_line().strip_edges()
		if line.is_empty() || line.begins_with("!"):
			continue
		if line.begins_with("||"):
			var domain = line.trim_prefix("||").split("^")[0].split("$")[0]
			domains.append(domain)
			
	# Wir übergeben die Liste an ein MutationObserver-Skript in JS, 
	# welches Werbe-Elemente (iframes, Bilder) mit diesen Domains im DOM blockiert/löscht.
	var js_template = """
		(function() {
			const badDomains = %s;
			const observer = new MutationObserver(() => {
				document.querySelectorAll('iframe, img, script').forEach(el => {
					let src = el.src || el.currentSrc;
					if (src) {
						badDomains.forEach(domain => {
							if (src.includes(domain)) el.remove();
						});
					}
				});
			});
			observer.observe(document.documentElement, { childList: true, subtree: true });
		})();
	""" % str(domains)
	return js_template

func clearMarks():
	markedElementsClass.clear()
	markedElementsName.clear()

func _load_easylist(path: String):
	if not FileAccess.file_exists(path):
		print("Fehler: easylist.txt wurde nicht gefunden!")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	var count = 0
	
	while not file.get_position() >= file.get_length():
		var line = file.get_line().strip_edges()
		
		# Überspringe Kommentare (beginnen mit !) und leere Zeilen
		if line.is_empty() || line.begins_with("!"):
			continue
			
		# Einfache Werbeblocker-Regeln filtern (z.B. ||werbung.de^ oder ||ads.com)
		if line.begins_with("||"):
			var domain = line.trim_prefix("||")
			# Sonderzeichen am Ende abschneiden (^ oder $)
			if "^" in domain:
				domain = domain.split("^")[0]
			if "$" in domain:
				domain = domain.split("$")[0]
				
			# In einem Dictionary abspeichern (wir nutzen Keys, da die Suche darin O(1) superschnell ist)
			ad_blacklist[domain] = true
			count += 1
			
	print("EasyList erfolgreich geladen! ", count, " Werbe-Regeln aktiv.")

#func on_cef_texture_load_finished(url: String, http_status_code: int) -> void:
	#$"../TabManager".ExcJS('document.head.innerHTML+="<style>* { border-radius:0px !important; }</style>"')
