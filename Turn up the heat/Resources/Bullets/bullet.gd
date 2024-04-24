extends Node2D

@export var speed: int = 750
@export var max_distance: int = 100
@export var max_pierce: int = 0
@export var max_bounces: int = 0
@export var is_split_active: bool = false
@export var is_ramp_up_active: bool = false
@export var ramp_up: int = 0

var is_timer_active: bool = false
var current_bounces: int = 0
var current_pierce: int = 0
var attack: float
var remaining_distance: int = 100
var bounce_distance: int = 700

func _ready():
	remaining_distance = max_distance
	current_pierce = max_pierce
	current_bounces = max_bounces
	if is_timer_active:
		$InvisTimer.start()

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed*delta
	if (remaining_distance<0): 
		end_of_life()

func bounce_to_closest(area: CharacterBody2D):
	if is_ramp_up_active:
		ramp_up+=1
	var distance_squared_to_closest: float = 9999999999
	var closest
	var all_enemy = $Bounce_check.get_overlapping_bodies()
	all_enemy.erase(area)
	for enemy in all_enemy:
		var distance = global_position.distance_squared_to(enemy.global_position)
		if distance_squared_to_closest>distance: 
			distance_squared_to_closest = distance
			closest = enemy
	if all_enemy:
		look_at(closest.get_parent().position)
	else:
		rotation_degrees = randi_range(0,360)

func _on_area_2d_body_entered(area):
	if $InvisTimer.is_stopped():
		var damage = attack*(1+ramp_up*0.15)
		if area is HitboxComponent:
			area.damage(damage)
			SignalBus.range_damage_dealt.emit(damage)
			current_pierce -= 1
			if is_ramp_up_active:
				ramp_up+=1
			if current_pierce<0:
				if current_bounces<=0:
					end_of_life()
				else:
					bounce_to_closest(area)
					current_bounces-=1

func end_of_life():
	if is_split_active:
		for x in range(1,6):
			var split = duplicate()
			split.global_position = global_position
			split.rotation_degrees = (60*x)
			split.attack = attack
			split.max_bounces = 0
			split.max_pierce = 0
			split.max_distance = 50
			split.is_timer_active = true
			split.is_ramp_up_active = is_ramp_up_active
			split.is_split_active = false
			get_parent().add_child.call_deferred(split)
	queue_free()
