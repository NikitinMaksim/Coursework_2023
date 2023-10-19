extends Control

@export var damage_dealt: float

func _ready():
	$Timer.start()
	$Label.text = "-"+str(damage_dealt)

func _physics_process(_delta):
	position.y-=0.5

func _on_timer_timeout():
	queue_free()
