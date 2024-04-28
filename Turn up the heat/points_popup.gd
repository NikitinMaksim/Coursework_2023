extends Control

@export var points: float

func _ready():
	$Timer.start()
	$Label.text = "Added "+str(points) + " points"

func _physics_process(_delta):
	position.y-=0.5

func _on_timer_timeout():
	queue_free()
