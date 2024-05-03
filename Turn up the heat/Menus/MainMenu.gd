extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Menus/CharacterSelectionMenu.tscn")

func _on_settings_pressed():
	$TextureRect/MarginContainer/VBoxContainer.visible = false
	$SettingsUI.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_ui_visibility_changed():
	if $SettingsUI.visible == false:
		$TextureRect/MarginContainer/VBoxContainer.visible = true
