extends Controller_component

@onready var weapon_sprite: Sprite2D
@onready var timer_fire_delay = $Timer_fire_delay
@onready var timer_reload = $Timer_reload
@onready var ammo_label = $Visual/AmmoLabel
@onready var reload_progress_bar = $Visual/ReloadProgressBar

var current_weapon: int = 0 
var weapons:Array
var max_clip: int = 0
var clip: int = 0
var second_weapon_clip: int = 0
var is_melee: bool = false

@export var current_ammo: int = 1
@export var max_ammo: int = 1
@export var current_fuel: float = 1
@export var max_fuel: int = 150

func on_ready() -> void:
	weapon_sprite = get_child(0).get_child(0)
	weapon_sprite.texture = parent.weapons[0].texture
	get_child(0).reparent(parent)
	weapons = parent.weapons
	clip = weapons[0].clip
	second_weapon_clip = weapons[1].clip
	current_ammo = max_ammo
	current_fuel = max_fuel
	update_magazine_label()

func process_input(event:InputEvent):
	if event.is_action_pressed("swap_weapon"):
		swap_weapon()

func process_physics(delta:float):
	if (Input.is_action_pressed("shoot") and timer_fire_delay.is_stopped() and timer_reload.is_stopped()):
		shoot()

func process_frame(delta:float):
	pass

func shoot():
	print("pew")

func swap_weapon():
	if current_weapon == 0:
		current_weapon = 1
	else: current_weapon = 0 
	weapon_sprite.texture = weapons[current_weapon].texture

func update_magazine_label():
	ammo_label.text = str(clip)+"/"+str(max_clip)
