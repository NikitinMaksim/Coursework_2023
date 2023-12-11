extends Control

func _on_continue_pressed():
	visible = false
	SignalBus.unpause_game.emit()

func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	SignalBus.unpause_game.emit()
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")

func _on_settings_pressed():
	$SettingsUI.visible = true

func _on_settings_ui_visibility_changed():
	$Menu.visible = !$SettingsUI.visible
