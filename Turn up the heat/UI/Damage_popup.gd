extends Control

@export var damage_dealt: float

func _ready():
	$Timer.start()
	$Label.text = "-"+str(damage_dealt)

func _on_timer_timeout():
	queue_free()
