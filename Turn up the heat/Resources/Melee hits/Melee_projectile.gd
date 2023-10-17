extends Node2D

@export var max_distance: int = 700
@export var speed: int = 100
@export var attack: float

var remaining_distance: int = 100

func _ready():
	remaining_distance = max_distance

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()

func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		area.damage(attack)
