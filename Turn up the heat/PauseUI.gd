extends Control


func _on_continue_pressed():
	SignalBus.pause_game.emit()


func _on_exit_pressed():
	get_tree().quit()
