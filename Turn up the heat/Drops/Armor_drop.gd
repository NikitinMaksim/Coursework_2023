extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.current_animation = "Drop"
	SignalBus.drop_spawned.emit(self)

func _on_body_entered(_body):
	SignalBus.repair_armor.emit(1)
	SignalBus.drop_despawned.emit(self)
	queue_free()
