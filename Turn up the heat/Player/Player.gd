extends CharacterBody2D

@onready var anitree : AnimationTree = $AnimationTree
@onready var gun = $Gun
@onready var timer_between_shots = $Timer_between_shots
@onready var timer_reload = $Timer_reload
@onready var label = $Control/Label
@onready var marker_2d = $Gun/Marker2D

signal change_offset(x)
signal set_ammo_ui(ammo)
signal set_max_ammo_ui(max_ammo)

@export var weapons: Array[GunData]
@export var body: BodyData

var direction : Vector2 = Vector2.ZERO
var current_gun: int = 0
var max_clip: int = 0
var clip: int = 0
var second_weapon_clip: int = 0
var is_melee: bool = false
var current_armor: int = 1
var current_ammo: int = 1
var max_ammo: int = 1

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
	$"../CanvasLayer/UI/Health".setArmor(current_armor)
	update_magazine_label()

func _process(_delta):
	update_animation_parameters()

func _physics_process(_delta):
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		velocity = direction * body.speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if (Input.is_action_pressed("shoot") and timer_between_shots.is_stopped() and timer_reload.is_stopped()):
			if clip>0:
				shoot()
			else: 
				reload()
	if (Input.is_action_just_pressed("swap_weapon")):
		swap_weapon()
	if (Input.is_action_just_pressed("reload")):
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
	var weapon = weapons[current_gun]
	clip -= weapon.fire_cost
	for x in weapon.projectiles_fired:
		var projectile = weapons[current_gun].projectile.instantiate()
		var spread = weapon.spread
		if (is_melee):
			pass
		else:
			projectile.max_pierce = weapon.pierce
			projectile.max_bounces = weapon.bounce
		projectile.speed = weapon.bullet_speed
		projectile.max_distance = weapon.bullet_max_distance
		projectile.attack = weapon.damage
		projectile.global_position = $Gun/Marker2D.global_position
		if weapon.projectiles_fired == 1:
			projectile.rotation = $Gun.rotation
		else:
			projectile.rotation = ($Gun.rotation - deg_to_rad(spread/2) + deg_to_rad(spread/(weapon.projectiles_fired-1)*x))
		owner.add_child(projectile)
	timer_between_shots.start()
	update_magazine_label()
	if clip<=0:
		reload()
	
func change_gun(choosen_gun: int):
	var weapon = weapons[choosen_gun]
	var store: int
	is_melee = choosen_gun
	gun.texture = weapon.texture
	max_clip = weapon.clip
	store = clip
	change_offset.emit(weapon.x_offset)
	clip = second_weapon_clip
	second_weapon_clip = store
	timer_between_shots.wait_time = 1/weapon.bullets_per_second
	timer_reload.wait_time = weapon.reload_time
	current_gun = choosen_gun
	update_magazine_label()
	
func swap_weapon():
	timer_reload.stop()
	if current_gun == 1: change_gun(0)
	else: change_gun(1)

func _on_timer_reload_timeout():
	if not is_melee:
		if current_ammo>max_clip:
			current_ammo -= max_clip-clip
			clip = max_clip
		elif current_ammo>0:
			clip = current_ammo
			current_ammo = 0
		else:
			pass
		set_ammo_ui.emit(current_ammo)
	else:
		clip = max_clip
	update_magazine_label()

func update_magazine_label():
	label.text = str(clip)+"/"+str(max_clip)

func reload():
	if timer_reload.is_stopped():
		if not is_melee:
			if current_ammo>0:
				timer_reload.start()
		else:
			timer_reload.start()
