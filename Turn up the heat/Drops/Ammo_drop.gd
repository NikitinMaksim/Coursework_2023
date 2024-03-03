extends Area2D


func _ready():
	$AnimationPlayer.current_animation = "Drop"

func _on_body_entered(_body):
	SignalBus.fill_ammo.emit(100)
	queue_free()
