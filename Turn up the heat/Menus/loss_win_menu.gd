extends Control

@onready var label = $VBoxContainer/Label

func _ready():
	SignalBus.loss.connect(_on_loss)
	SignalBus.win.connect(_on_win)

func _on_loss():
	label.text = "You lost"

func _on_win():
	label.text = "You won!"

func _on_exit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	SignalBus.unpause_game.emit()
	get_tree().change_scene_to_file("res://Main_scene.tscn")

func _on_try_again_pressed():
	SignalBus.unpause_game.emit()
	get_tree().change_scene_to_file("res://Main_scene.tscn")
