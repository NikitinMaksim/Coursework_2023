extends Node2D

@export var target: Node2D
@export var speed: int = 750
@export var max_distance: int = 100
@export var max_pierce: int = 0
@export var max_bounces: int = 0

var attack: float
var remaining_distance: int = 100
var bounce_distance: int = 700

func _process(delta):
	if is_instance_valid(target):
		look_at(target.global_position)
		position += transform.x * speed * delta
	else: 
		queue_free()

func _on_area_2d_area_entered(area):
	area.get_parent().queue_free()
	queue_free()
