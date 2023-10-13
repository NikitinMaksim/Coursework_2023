extends Control
@export var damage_dealt: float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$Label.text = "-"+str(damage_dealt)

func _on_timer_timeout():
	queue_free()
