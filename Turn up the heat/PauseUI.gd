extends Control

func _on_continue_pressed():
	visible = false
	SignalBus.unpause_game.emit()

func _on_exit_pressed():
	get_tree().quit()
