extends CharacterBody2D

@export var speed : float = 300.0

@onready var anitree : AnimationTree = $AnimationTree
@onready var gun = $Gun
@onready var timer_between_shots = $Timer_between_shots
@onready var timer_reload = $Timer_reload
@onready var label = $Control/Label

@export var weapons: Array[GunData]

var direction : Vector2 = Vector2.ZERO
var current_gun: int = 0
@export var max_clip: int = 0
@export var clip: int = 0
var second_weapon_clip: int = 0

func _ready():
	anitree.active = true
	change_gun(current_gun)
	clip = weapons[0].clip
	second_weapon_clip = weapons[1].clip
	update_magazine_label()

func _process(_delta):
	update_animation_parameters()

func _physics_process(_delta):
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		velocity = direction * speed
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
	clip -= 1
	var weapon = weapons[current_gun]
	var bullet = weapons[current_gun].projectile.instantiate()
	bullet.speed = weapon.bullet_speed
	bullet.max_distance = weapon.bullet_max_distance
	bullet.global_position = $Gun/Marker2D.global_position
	bullet.rotation = $Gun.rotation
	owner.add_child(bullet)
	timer_between_shots.start()
	update_magazine_label()
	
func change_gun(choosen_gun: int):
	var weapon = weapons[choosen_gun]
	var store: int
	gun.texture = weapon.texture
	max_clip = weapon.clip
	store = clip
	clip = second_weapon_clip
	second_weapon_clip = store
	timer_between_shots.wait_time = 1/weapon.bullets_per_second
	timer_reload.wait_time = weapon.reload_time
	current_gun = choosen_gun
	update_magazine_label()
	
func swap_weapon():
	if current_gun == 1: change_gun(0)
	else: change_gun(1)

func _on_timer_reload_timeout():
	clip = max_clip
	update_magazine_label()

func update_magazine_label():
	label.text = str(clip)+"/"+str(max_clip)

func reload():
	timer_reload.start()
