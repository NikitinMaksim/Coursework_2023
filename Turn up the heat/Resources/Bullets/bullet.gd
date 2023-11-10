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

func _ready():
	remaining_distance = max_distance
	current_pierce = max_pierce
	current_bounces = max_bounces

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()

func bounce_to_closest(area: CharacterBody2D):
	var distance_to_closest: float = 9999999999
	var closest
	var all_enemy = $Bounce_check.get_overlapping_bodies()
	all_enemy.erase(area)
	for enemy in all_enemy:
		var distance = global_position.distance_to(enemy.global_position)
		if distance_to_closest>distance: 
			distance_to_closest = distance
			closest = enemy
	if all_enemy:
		look_at(closest.get_parent().position)
	else:
		rotation_degrees = randi_range(0,360)


func _on_area_2d_body_entered(area):
	if area is HitboxComponent:
		area.damage(attack)
		SignalBus.range_damage_dealt.emit(attack)
		current_pierce -= 1
		if current_pierce<0:
			if current_bounces<=0:
				queue_free()
			else:
				bounce_to_closest(area)
				current_bounces-=1
