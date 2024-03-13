extends CharacterBody2D

@onready var anitree : AnimationTree = $AnimationTree
@onready var gun: Node = $Gun
@onready var timer_between_shots: Node = $Timer_between_shots
@onready var timer_reload: Node = $Timer_reload
@onready var label: Node = $Control/Label
@onready var marker_2d: Node = $Gun/Marker2D
@onready var timer_rage: Node = $Timer_Rage

const LITTLE_FUEL_DROP = preload("res://Drops/LittleFuelDrop.tscn")

signal change_offset(x)
signal set_ammo_ui(ammo)
signal set_max_ammo_ui(max_ammo)
signal set_fuel_ui(fuel)
signal set_max_fuel_ui(max_fuel)
signal level_up()
signal set_exp_ui(exp)
signal set_max_exp_ui(max_exp)

@export var weapons: Array[GunData]
@export var body: BodyData

@export var current_ammo: int = 1
@export var max_ammo: int = 1
@export var current_fuel: float = 1
@export var max_fuel: int = 150

var direction : Vector2 = Vector2.ZERO
var current_gun: int = 0
var max_clip: int = 0
var clip: int = 0
var second_weapon_clip: int = 0
var is_melee: bool = false
var current_armor: int = 1
var fuel_attack_speed_modifier: float = 1
var fuel_move_speed_modifier: float = 1
var can_shoot: bool = true

var level: int = 1
var total_exp: int = 0
var exp_till_next_lvl: int = 1

var exp_for_ammo_counter: int = 0
var exp_for_armor_counter: int = 0
var rage_damage_modifier: float = 0
var armor_damage_modifier: float = 0

var modifiers = {
	"damage":0,
	"attack_speed":0,
	"pierce":0,
	"max_ammo":0,
	"magazine_size":0,
	"bounce":0,
	"projectile":0,
	"spread":0,
	"max_fuel":0,
	"speed":0,
	"is_split_active":false,
	"is_backwards_fire_active":false,
	"is_rampup_active":false,
	"is_armor_crafting_active":false,
	"is_rage_active":false,
	"is_armor_to_damage_active":false,
	"is_ammo_crafting_active":false,
	"is_fuel_drops_active":false
}

func _ready():
	anitree.active = true
	$Sprite2D.texture=body.sprite_sheet
	change_gun(current_gun)
	clip = weapons[0].clip
	second_weapon_clip = weapons[1].clip
	current_armor = body.armor_platings
	max_ammo = body.max_ammo
	set_max_ammo_ui.emit(max_ammo)
	current_ammo = max_ammo
	max_fuel = body.max_fuel
	set_max_fuel_ui.emit(max_fuel)
	current_fuel = max_fuel
	$"../CanvasLayer/Action_UI/Grid/Left up corner/Health".setArmor(current_armor)
	update_magazine_label()
	exp_till_next_lvl = 1+pow(level,2)
	
	SignalBus.fill_ammo.connect(Callable(_fill_ammo.bind()))
	SignalBus.fill_fuel.connect(Callable(_fill_fuel.bind()))
	SignalBus.repair_armor.connect(Callable(_repair_armor.bind()))
	SignalBus.player_hurt.connect(Callable(hurt.bind()))
	SignalBus.add_exp.connect(Callable(get_exp.bind()))
	SignalBus.modify_player_stats.connect(Callable(change_stats.bind()))
	SignalBus.swap_can_shoot.connect(_on_swap_can_shoot)
	SignalBus.enemy_died.connect(Callable(_on_enemy_kill.bind()))

func _process(_delta):
	update_animation_parameters()

func _physics_process(_delta):
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		velocity = direction * (body.speed*fuel_move_speed_modifier*(1+float(modifiers["speed"])/100))
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if (Input.is_action_pressed("shoot") and timer_between_shots.is_stopped() and timer_reload.is_stopped() and can_shoot==true):
			if clip>0:
				shoot()
			else: 
				reload()
	elif (Input.is_action_just_pressed("swap_weapon")):
		swap_weapon()
	elif (Input.is_action_just_pressed("reload") and clip<max_clip):
		reload()

func update_animation_parameters():
	if (direction == Vector2.ZERO):
		anitree["parameters/conditions/is_idle"] = true
		anitree["parameters/conditions/is_walking"] = false
	else:
		anitree["parameters/conditions/is_idle"] = false
		anitree["parameters/conditions/is_walking"] = true
		anitree["parameters/Idle/blend_position"] = direction
		anitree["parameters/Walk/blend_position"] = direction

func shoot():
	var weapon: GunData = weapons[current_gun]
	var damage: float = weapon.damage*(1+(float(modifiers["damage"])/100)+rage_damage_modifier+armor_damage_modifier)
	var aspeed: float = (weapon.bullets_per_second*(1+float(modifiers["attack_speed"])/100)*fuel_attack_speed_modifier)
	SignalBus.add_points.emit(round((damage+aspeed)/20))
	clip -= weapon.fire_cost
	var projectiles_count = weapon.projectiles_fired+modifiers["projectile"]
	for x in projectiles_count:
		var projectile = weapons[current_gun].projectile.instantiate()
		var spread = weapon.spread+modifiers["spread"]
		if (is_melee):
			pass
		else:
			projectile.is_ramp_up_active = modifiers["is_rampup_active"]
			projectile.is_split_active = modifiers["is_split_active"]
			projectile.max_pierce = weapon.pierce+modifiers["pierce"]
			projectile.max_bounces = weapon.bounce+modifiers["bounce"]
		projectile.speed = weapon.bullet_speed
		projectile.max_distance = weapon.bullet_max_distance
		projectile.attack = damage
		projectile.global_position = $Gun/Marker2D.global_position
		if projectiles_count == 1:
			projectile.rotation = $Gun.rotation
		else:
			projectile.rotation = ($Gun.rotation - deg_to_rad(spread/2) + deg_to_rad(spread/(projectiles_count-1)*x))
		owner.add_child(projectile)
	if modifiers["is_backwards_fire_active"]:
		var projectile = weapons[current_gun].projectile.instantiate()
		if (is_melee):
			pass
		else:
			projectile.max_pierce = weapon.pierce+modifiers["pierce"]
			projectile.max_bounces = weapon.bounce+modifiers["bounce"]
		projectile.speed = weapon.bullet_speed
		projectile.max_distance = weapon.bullet_max_distance
		projectile.attack = weapon.damage*(1+(float(modifiers["damage"])/100)+rage_damage_modifier+armor_damage_modifier)
		projectile.global_position = $Gun/Marker2D.global_position
		projectile.rotation = $Gun.rotation+deg_to_rad(180)
		owner.add_child(projectile)
	timer_between_shots.start()
	SoundBus.play_shoot_sound()
	update_magazine_label()
	if clip<=0:
		reload()

func change_gun(choosen_gun: int):
	var weapon = weapons[choosen_gun]
	var store: int
	is_melee = choosen_gun
	gun.texture = weapon.texture
	max_clip = weapon.clip*(1+float(modifiers["magazine_size"])/100)
	store = clip
	change_offset.emit(weapon.x_offset)
	clip = second_weapon_clip
	second_weapon_clip = store
	timer_between_shots.wait_time = 1/(weapon.bullets_per_second*(1+float(modifiers["attack_speed"])/100)*fuel_attack_speed_modifier)
	timer_reload.wait_time = weapon.reload_time
	current_gun = choosen_gun
	update_magazine_label()

func swap_weapon():
	timer_reload.stop()
	if current_gun == 1: change_gun(0)
	else: change_gun(1)

func _on_timer_reload_timeout():
	if not is_melee:
		current_ammo += clip
		clip = clamp(current_ammo,0,max_clip)
		current_ammo -= clip
		set_ammo_ui.emit(current_ammo)
	else:
		current_fuel += clip
		clip = clamp(current_fuel,0,max_clip)
		current_fuel -= clip
		set_fuel_ui.emit(current_fuel)
	update_magazine_label()
	SoundBus.play_reload_sound()

func update_magazine_label():
	label.text = str(clip)+"/"+str(max_clip)

func reload():
	if timer_reload.is_stopped():
		if not is_melee:
			if current_ammo>0:
				timer_reload.start()
		else:
			timer_reload.start()

func _on_timer_fuel_timeout():
	if current_fuel>0:
		if current_fuel>=max_fuel:
			$Timer_fuel.wait_time=0.3
			fuel_attack_speed_modifier = 1+((current_fuel/max_fuel)-1)*0.3
			fuel_move_speed_modifier = 1+((current_fuel/max_fuel)-1)*0.5
		else:
			$Timer_fuel.wait_time=1
			fuel_attack_speed_modifier = 1-((1-(current_fuel/max_fuel))*0.3)
			fuel_move_speed_modifier = 1-((1-(current_fuel/max_fuel))*0.8)
		current_fuel -= body.fuel_usage_every_sec
		current_fuel=clamp(current_fuel,0,max_fuel*2)
	else:
		fuel_attack_speed_modifier = 1
		fuel_move_speed_modifier = 1
		if current_ammo>0:
			current_ammo -= max_ammo/20
			current_ammo = clamp(current_ammo,0,max_ammo)
			set_ammo_ui.emit(current_ammo)
		else:
			hurt(1)
	set_fuel_ui.emit(current_fuel)
	$Timer_between_shots.wait_time=1/(weapons[current_gun].bullets_per_second*fuel_attack_speed_modifier*(1+float(modifiers["attack_speed"])/100))

func _fill_ammo(amount):
	current_ammo+=amount
	current_ammo=clamp(current_ammo,0,max_ammo)
	set_ammo_ui.emit(current_ammo)

func _fill_fuel(amount):
	current_fuel+=amount
	current_fuel=clamp(current_fuel,0,max_fuel*2)
	set_fuel_ui.emit(current_fuel)
	if current_fuel>max_fuel:
		$Timer_fuel.wait_time=0.3
	else:
		$Timer_fuel.wait_time=1

func _repair_armor(amount):
	current_armor+=amount
	$"../CanvasLayer/Action_UI/Grid/Left up corner/Health".setArmor(current_armor)
	if modifiers["is_armor_to_damage_active"]:
		armor_damage_modifier=0.05*current_armor

func hurt(damage):
	var enemys = $Area2D.get_overlapping_bodies()
	for enemy in enemys:
		enemy.owner.is_knocked_back = true
	if $"I-Frames".is_stopped():
		if current_armor>0:
			current_armor -= damage
			$"../CanvasLayer/Action_UI/Grid/Left up corner/Health".setArmor(current_armor)
			if modifiers["is_rage_active"]:
				$Timer_Rage.start()
				rage_damage_modifier=0.30
			if modifiers["is_armor_to_damage_active"]:
				armor_damage_modifier=0.05*current_armor
		else:
			$"../CanvasLayer/Loss_win_menu".visible = true
			SignalBus.loss.emit()
			SignalBus.pause_game.emit()
		if current_armor == 0:
			SignalBus.add_points.emit(10)
		else:
			SignalBus.add_points.emit(damage*-10)
		$"I-Frames".start()

func get_exp(amount):
	total_exp+=amount
	if total_exp>=exp_till_next_lvl:
		total_exp -= exp_till_next_lvl
		exp_till_next_lvl = 1+pow(level,2)
		set_max_exp_ui.emit(exp_till_next_lvl)
		level+=1
		level_up.emit()
	if modifiers["is_armor_crafting_active"]:
		exp_for_armor_counter+=amount
		if exp_for_armor_counter>300:
			exp_for_armor_counter-=300
			_repair_armor(1)
	if modifiers["is_ammo_crafting_active"]:
		exp_for_ammo_counter+=amount
		if exp_for_ammo_counter>3:
			exp_for_ammo_counter-=3
			_fill_ammo(1)
	set_exp_ui.emit(total_exp)

func change_stats(stat,value):
	if typeof(value)==TYPE_INT:
		if stat == "armor":
			_repair_armor(value)
		else:
			modifiers[stat]+=value
	else:
		modifiers[stat]=value
	if modifiers["is_armor_to_damage_active"]:
		armor_damage_modifier=0.05*current_armor
	if stat == "attack_speed":
		timer_between_shots.wait_time = 1/(weapons[current_gun].bullets_per_second*(1+float(modifiers["attack_speed"])/100)*fuel_attack_speed_modifier)
	if stat == "max_ammo":
		max_ammo = body.max_ammo*(1+float(modifiers["max_ammo"])/100)
		set_max_ammo_ui.emit(max_ammo)
		set_ammo_ui.emit(current_ammo)
	if stat == "magazine_size":
		max_clip = weapons[0].clip*(1+float(modifiers["magazine_size"])/100)
		second_weapon_clip = weapons[1].clip*(1+float(modifiers["magazine_size"])/100)
		update_magazine_label()
	if stat == "max_fuel":
		max_fuel = body.max_fuel*(1+float(modifiers["max_fuel"])/100)
		set_max_fuel_ui.emit(max_fuel)
		set_fuel_ui.emit(current_fuel)

func _on_swap_can_shoot():
	can_shoot = !can_shoot

func _on_enemy_kill(place, stats):
	if modifiers["is_fuel_drops_active"]:
		var drop = LITTLE_FUEL_DROP.instantiate()
		drop.global_position = place
		get_parent().add_child.call_deferred(drop)
	SoundBus.play_die_sound()

func _on_timer_rage_timeout():
	rage_damage_modifier = 0
