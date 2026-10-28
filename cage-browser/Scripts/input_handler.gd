extends Node2D

var openforKP = false
var fullscreen = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_find_in_page"):
		$"../TabManager".FindInPage()
	elif Input.is_action_just_pressed("ui_fip_next"):
		$"../TabManager".FIPNext()
	elif Input.is_action_just_pressed("ui_fip_previous"):
		$"../TabManager".FIPPrevious()
	elif Input.is_action_just_pressed("ui_focus_url"):
		$"../SearchBar".visible = true
		
		var target_input = $"../SearchBar/LineEdit"
		target_input.set_focus_mode(Control.FOCUS_ALL)
		
		await get_tree().process_frame
		target_input.grab_focus()
	elif Input.is_action_just_pressed("ui_back"):
		$"../TabManager".UndoBack()
	elif Input.is_action_just_pressed("ui_forward"):
		$"../TabManager".RedoForward()
	elif Input.is_action_just_pressed("ui_new_tab"):
		$"../TabManager".NewTab()
	elif Input.is_action_just_pressed("ui_close_tab"):
		$"../TabManager".CloseTab()
	elif Input.is_action_just_pressed("ui_zoom_in"):
		$"../TabManager".ZoomIn()
	elif Input.is_action_just_pressed("ui_reset_zoom"):
		$"../TabManager".ResetZoom()
	elif Input.is_action_just_pressed("ui_zoom_out"):
		$"../TabManager".ZoomOut()
	elif Input.is_action_just_pressed("ui_reload"):
		$"../TabManager".ReloadTab()
	elif Input.is_action_just_pressed("ui_force_reload"):
		$"../TabManager".ForceReloadTab()
	elif Input.is_action_just_pressed("ui_switch_tab"):
		$"../TabManager".SwitchTab()
	#elif Input.is_action_just_pressed("ui_open_devtools"):
	#	$"../TabManager".OpenDevTools()
#	elif Input.is_action_just_pressed("ui_search_focus"):
#		$"../TabManager".ExcJS('''var inputs, index;
#inputs = document.querySelectorAll('input, textarea');
#for (index = 0; index < inputs.length; ++index) {
#    console.log("Marked:'" + inputs[index].outerHTML + "'" + inputs[index].className)
#	var number = document.createElement("p");
#	number.textContent = index.toString()
#	inputs[index].parentElement.appendChild(number);
#} ''')
#		openforKP = true
	elif openforKP:
		var maxKP = len($"../Tabs".markedElementsClass)
		if Input.is_action_just_pressed("ui_0"):
			if maxKP >= 1:
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[0]+'''")
				console.log(element.outerHTML)
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_1"):
			if maxKP >= 2:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[1]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_2"):
			if maxKP >= 3:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[2]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_3"):
			if maxKP >= 4:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[3]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_4"):
			if maxKP >= 5:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[4]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_5"):
			if maxKP >= 6:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[5]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_6"):
			if maxKP >= 7:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[6]+'''")
				
setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
        searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_7"):
			if maxKP >= 8:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[7]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_8"):
			if maxKP >= 9:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[8]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
		elif Input.is_action_just_pressed("ui_9"):
			if maxKP >= 10:
				
				print("Exec JS")
				$"../TabManager".ExcJS('''
				var element = document.querySelector(".'''+$"../Tabs".markedElementsClass[9]+'''")
				
				setTimeout(() => {
    const searchInput = element;
    window.focus()
	document.body.click()
    if (searchInput) {
        // 1. Klick-Event simulieren, um YouTubes UI-Status auf "aktiv" zu setzen
		searchInput.dispatchEvent(new MouseEvent('mousedown', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new MouseEvent('mouseup', { bubbles: true, cancelable: true }));
		searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		searchInput.click();
        
        // 2. Den Fokus erzwingen
        searchInput.focus();
        
        // 3. WICHTIG FÜR YOUTUBE: Ein "input"-Event feuern. 
        // Das signalisiert dem Framework, dass Text eingegeben werden darf.
        
        
        console.log("YouTube-Suchfeld erfolgreich aktiviert!");
    } else {
        console.log("Suchfeld nicht gefunden.");
    }
}, 500);

				''')
				print("Clearing Marks")
				$"../Tabs".clearMarks()
				print("Done!")
				openforKP = false
	elif Input.is_action_just_pressed("ui_toggle_tabs"):
		var tabs = $"../Tabs"
		tabs.visible = !tabs.visible
		if tabs.visible:
			fullscreen = false
			$"../TabManager".ExitFullscreenEverything()
		else:
			fullscreen = true
			$"../TabManager".FullscreenEverything()
	elif Input.is_action_just_pressed("ui_open_downloads"):
		pass
