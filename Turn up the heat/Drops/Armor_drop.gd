extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.current_animation = "Drop"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	SignalBus.repair_armor.emit(1)
	queue_free()
