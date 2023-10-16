extends Node2D

@export var speed: int = 750
@export var max_distance: int = 100
@export var max_pierce: int = 0
@export var max_bounces: int = 0
var current_bounces: int = 0
var current_pierce: int = 0
var attack: float
var remaining_distance: int = 100
var bounce_distance: int = 700
# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_distance = max_distance
	current_pierce = max_pierce
	current_bounces = max_bounces

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()
	

func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		area.damage(attack)
		current_pierce -= 1
		if current_pierce<0:
			if current_bounces<=0:
				queue_free()
			else:
				bounce_to_closest(area)
				current_bounces-=1

func bounce_to_closest(area: Area2D):
	var distance_to_closest: float = 0
	var closest
	var all_enemy = $Bounce_check.get_overlapping_areas()
	all_enemy.erase(area)
	for enemy in all_enemy:
		var distance = position.distance_to(enemy.position)
		if distance_to_closest<distance and distance_to_closest>=0: 
			distance_to_closest = distance
			closest = enemy
	look_at(closest.get_parent().position)
	
