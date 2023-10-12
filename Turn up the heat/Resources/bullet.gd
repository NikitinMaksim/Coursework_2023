extends Node2D

@export var speed: int = 750
@export var max_distance: int = 100
var remaining_distance: int = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_distance = max_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()
