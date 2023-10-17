extends Node2D

@export var speed: int = 750
@export var max_distance: int = 100

var remaining_distance: int = 100

func _ready():
	remaining_distance = max_distance

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()
