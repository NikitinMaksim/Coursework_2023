extends Timer


func _on_visible_on_screen_notifier_2d_screen_entered():
	stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	start()
