extends Control

var config: ConfigFile = ConfigFile.new()
var savepath: String = "user://settings.cfg"

func _ready():
	load_settings()
	AudioServer.set_bus_volume_db(0,linear_to_db($Panel/TabContainer/Audio/Main/MainSlider.value))
	AudioServer.set_bus_volume_db(1,linear_to_db($Panel/TabContainer/Audio/Music/MusicSlider.value))
	AudioServer.set_bus_volume_db(2,linear_to_db($Panel/TabContainer/Audio/Effects/EffectsSlider.value))

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
	load_settings()

func _on_effects_slider_drag_ended(_value_changed):
	SoundBus.play_shoot_sound()

func save_settings():
	var err = config.load(savepath)
	if err != OK:
		print("Ошибка:", str(err))
	config.set_value("Audio", "Master",db_to_linear(AudioServer.get_bus_volume_db(0)))
	config.set_value("Audio", "Music",db_to_linear(AudioServer.get_bus_volume_db(1)))
	config.set_value("Audio", "Effects",db_to_linear(AudioServer.get_bus_volume_db(2)))
	config.save(savepath)

func load_settings():
	config.load(savepath)
	$Panel/TabContainer/Audio/Main/MainSlider.value = config.get_value("Audio","Master")
	$Panel/TabContainer/Audio/Music/MusicSlider.value = config.get_value("Audio","Music")
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = config.get_value("Audio","Effects")

func _on_apply_button_pressed():
	save_settings()

func _on_reset_button_pressed():
	load_settings()

func _on_default_button_pressed():
	$Panel/TabContainer/Audio/Main/MainSlider.value = db_to_linear(-5.9)
	$Panel/TabContainer/Audio/Music/MusicSlider.value = db_to_linear(-5.9)
	$Panel/TabContainer/Audio/Effects/EffectsSlider.value = db_to_linear(-5.9)
