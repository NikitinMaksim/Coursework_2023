extends Area2D

func _ready():
	$AnimationPlayer.current_animation = "Drop"

func _on_body_entered(_body):
	SignalBus.repair_armor.emit(1)
	queue_free()
