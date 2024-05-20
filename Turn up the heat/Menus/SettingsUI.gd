extends Control

var config: ConfigFile = ConfigFile.new()
var savepath: String = "user://settings.cfg"

func _ready():
	config.load(savepath)
	$Panel/TabContainer/Audio/Main/MainSlider.value = config.get_value("Audio","Master")
	$Panel/TabContainer/Audio/Music/MusicSlider.value = config.get_value("Audio","Music")
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = config.get_value("Audio","Effects")
	AudioServer.set_bus_volume_db(0,linear_to_db($Panel/TabContainer/Audio/Main/MainSlider.value))
	AudioServer.set_bus_volume_db(1,linear_to_db($Panel/TabContainer/Audio/Music/MusicSlider.value))
	AudioServer.set_bus_volume_db(2,linear_to_db($Panel/TabContainer/Audio/Effects/EffectsSlider.value))
	if config.get_value("Video","FullScreen") == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = true
	else: 
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = false
	if config.get_value("Video","VSync") == DisplayServer.VSYNC_ENABLED:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = true
	else:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = false
	InputMap.action_erase_events("move_left")
	InputMap.action_add_event("move_left",config.get_value("Keybinds","move_left")[0])
	InputMap.action_erase_events("move_right")
	InputMap.action_add_event("move_right",config.get_value("Keybinds","move_right")[0])
	InputMap.action_erase_events("move_up")
	InputMap.action_add_event("move_up",config.get_value("Keybinds","move_up")[0])
	InputMap.action_erase_events("move_down")
	InputMap.action_add_event("move_down",config.get_value("Keybinds","move_down")[0])
	InputMap.action_erase_events("swap_weapon")
	InputMap.action_add_event("swap_weapon",config.get_value("Keybinds","swap_weapon")[0])
	InputMap.action_erase_events("reload")
	InputMap.action_add_event("reload",config.get_value("Keybinds","reload")[0])
	InputMap.action_erase_events("LevelUp")
	InputMap.action_add_event("LevelUp",config.get_value("Keybinds","LevelUp")[0])
	for i in get_tree().get_nodes_in_group("hotkey_button"):
		i._ready()

func _on_main_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))

func _on_effects_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))

func _on_exit_pressed():
	if visible==true:
		visible = false

func _on_visibility_changed():
	config.load(savepath)
	$Panel/TabContainer/Audio/Main/MainSlider.value = config.get_value("Audio","Master")
	$Panel/TabContainer/Audio/Music/MusicSlider.value = config.get_value("Audio","Music")
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = config.get_value("Audio","Effects")
	if config.get_value("Video","FullScreen") == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = true
	else: 
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = false
	if config.get_value("Video","VSync") == DisplayServer.VSYNC_ENABLED:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = true
	else:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = false
	#InputMap.action_erase_events("move_left")
	#InputMap.action_add_event("move_left",config.get_value("Keybinds","move_left")[0])
	#InputMap.action_erase_events("move_right")
	#InputMap.action_add_event("move_right",config.get_value("Keybinds","move_right")[0])
	#InputMap.action_erase_events("move_up")
	#InputMap.action_add_event("move_up",config.get_value("Keybinds","move_up")[0])
	#InputMap.action_erase_events("move_down")
	#InputMap.action_add_event("move_down",config.get_value("Keybinds","move_down")[0])
	#InputMap.action_erase_events("swap_weapon")
	#InputMap.action_add_event("swap_weapon",config.get_value("Keybinds","swap_weapon")[0])
	#InputMap.action_erase_events("reload")
	#InputMap.action_add_event("reload",config.get_value("Keybinds","reload")[0])
	#InputMap.action_erase_events("LevelUp")
	#InputMap.action_add_event("LevelUp",config.get_value("Keybinds","LevelUp")[0])
	#for i in get_tree().get_nodes_in_group("hotkey_button"):
		#i._ready()

func _on_effects_slider_drag_ended(_value_changed):
	SoundBus.play_shoot_sound()

func _on_apply_button_pressed():
	var err = config.load(savepath)
	if err != OK:
		print("Ошибка:", str(err))
	config.set_value("Audio", "Master",db_to_linear(AudioServer.get_bus_volume_db(0)))
	config.set_value("Audio", "Music",db_to_linear(AudioServer.get_bus_volume_db(1)))
	config.set_value("Audio", "Effects",db_to_linear(AudioServer.get_bus_volume_db(2)))
	config.save(savepath)

func _on_reset_button_pressed():
	config.load(savepath)
	$Panel/TabContainer/Audio/Main/MainSlider.value = config.get_value("Audio","Master")
	$Panel/TabContainer/Audio/Music/MusicSlider.value = config.get_value("Audio","Music")
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = config.get_value("Audio","Effects")

func _on_default_button_pressed():
	$Panel/TabContainer/Audio/Main/MainSlider.value = db_to_linear(-5.9)
	$Panel/TabContainer/Audio/Music/MusicSlider.value = db_to_linear(-5.9)
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = db_to_linear(-5.9)

func _on_full_screen_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_v_sync_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_v_apply_button_pressed():
	var err = config.load(savepath)
	if err != OK:
		print("Ошибка:", str(err))
	config.set_value("Video", "FullScreen",DisplayServer.window_get_mode())
	config.set_value("Video", "VSync",DisplayServer.window_get_vsync_mode())
	config.save(savepath)

func _on_v_reset_button_pressed():
	if config.get_value("Video","FullScreen") == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = true
	else: 
		$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = false
	if config.get_value("Video","VSync") == DisplayServer.VSYNC_ENABLED:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = true
	else:
		$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = false

func _on_v_default_button_pressed():
	$Panel/TabContainer/Video/HBoxContainer/LeftColumn/FullScreenContainer/FullScreenButton.button_pressed = true
	$"Panel/TabContainer/Video/HBoxContainer/LeftColumn/V-SyncContainer2/V-SyncButton".button_pressed = false

func _on_c_apply_button_pressed():
	var err = config.load(savepath)
	if err != OK:
		print("Ошибка:", str(err))
	config.set_value("Keybinds","move_left",InputMap.action_get_events("move_left"))
	config.set_value("Keybinds","move_right",InputMap.action_get_events("move_right"))
	config.set_value("Keybinds","move_up",InputMap.action_get_events("move_up"))
	config.set_value("Keybinds","move_down",InputMap.action_get_events("move_down"))
	config.set_value("Keybinds","swap_weapon",InputMap.action_get_events("swap_weapon"))
	config.set_value("Keybinds","reload",InputMap.action_get_events("reload"))
	config.set_value("Keybinds","LevelUp",InputMap.action_get_events("LevelUp"))
	config.save(savepath)

func _on_c_reset_button_pressed():
	for i in get_tree().get_nodes_in_group("hotkey_button"):
		i.rebind_action_key(config.get_value("Keybinds",i.action_name)[0])

func _on_c_default_button_pressed():
	InputMap.action_erase_events("move_left")
	var a:InputEventKey = InputEventKey.new()
	a.physical_keycode = KEY_A
	InputMap.action_add_event("move_left",a)
	InputMap.action_erase_events("move_right")
	var d:InputEventKey = InputEventKey.new()
	d.physical_keycode = KEY_D
	InputMap.action_add_event("move_right",d)
	InputMap.action_erase_events("move_up")
	var w:InputEventKey = InputEventKey.new()
	w.physical_keycode = KEY_W
	InputMap.action_add_event("move_up",w)
	InputMap.action_erase_events("move_down")
	var s:InputEventKey = InputEventKey.new()
	s.physical_keycode = KEY_S
	InputMap.action_add_event("move_down",s)
	InputMap.action_erase_events("swap_weapon")
	var e:InputEventKey = InputEventKey.new()
	e.physical_keycode = KEY_E
	InputMap.action_add_event("swap_weapon",e)
	InputMap.action_erase_events("reload")
	var r:InputEventKey = InputEventKey.new()
	r.physical_keycode = KEY_R
	InputMap.action_add_event("reload",r)
	InputMap.action_erase_events("LevelUp")
	var spc:InputEventKey = InputEventKey.new()
	spc.physical_keycode = KEY_SPACE
	InputMap.action_add_event("LevelUp",spc)
	for i in get_tree().get_nodes_in_group("hotkey_button"):
		i._ready()
