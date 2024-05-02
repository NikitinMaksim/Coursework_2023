extends Node2D

#Rotation data
@export var orbit_target: Node2D
var d: float = 0
var orbit_speed: int = 2
var move_speed: int = 600
var radius: int = 300
var orbit_position: Vector2
var is_on_stable_orbit: bool = false

#Crates data
var crates: Array
var target: Node2D
var is_flying_towards_crate: bool = false
var is_flying_to_player: bool = false
var holding_crate: Area2D

func _ready():
	$AnimationPlayer.active = true
	$AnimationPlayer.current_animation = "Idle"
	SignalBus.drop_spawned.connect(Callable(_on_drop_spawned.bind()))
	SignalBus.drop_despawned.connect(Callable(_on_drop_despawned.bind()))

func _process(delta):
	d += delta
	if d>2*PI:
		d = 0
	orbit_position = (Vector2(sin(d*orbit_speed)*radius,cos(d*orbit_speed)*radius)+orbit_target.global_position)
	if is_flying_towards_crate:
		is_on_stable_orbit = false
		if is_instance_valid(target):
			position = position.move_toward(target.global_position, move_speed*delta) 
	elif is_flying_to_player:
		is_on_stable_orbit = false
		position = position.move_toward(orbit_target.global_position, move_speed*delta) 
		if global_position.distance_squared_to(orbit_target.global_position)<150000:
			if holding_crate:
				holding_crate.set_collision_layer_value(3,false)
				holding_crate.reparent(owner)
				crates.erase(holding_crate)
				holding_crate = null
			is_flying_to_player = false
			if crates.size() == 0:
				is_flying_towards_crate = false
			else: 
				is_flying_towards_crate = true
				find_target()
	else:
		if is_on_stable_orbit:
			position = orbit_position
		else:
			position = position.move_toward(orbit_position, move_speed*delta) 
			if global_position.distance_squared_to(orbit_target.global_position)<122500 and global_position.distance_squared_to(orbit_position)<250:
				is_on_stable_orbit = true

func _on_drop_spawned(interal_target):
	crates.append(interal_target)
	find_target()

func find_target():
	if crates.size()>0:
		if crates.size()==1:
			target = crates[0]
		else:
			var furthest = crates[0]
			for crate in crates:
				if orbit_target.global_position.distance_squared_to(crate.global_position)<orbit_target.global_position.distance_squared_to(furthest.global_position):
					furthest = crate
			target = furthest
		is_flying_towards_crate = true
	else:
		is_flying_towards_crate = false
		is_flying_to_player = true

func _on_drop_despawned(interal_target):
	crates.erase(interal_target)
	find_target()

func _on_area_2d_area_entered(area):
	holding_crate = area
	holding_crate.call_deferred("reparent",self)
	is_flying_towards_crate = false
	is_flying_to_player = true
