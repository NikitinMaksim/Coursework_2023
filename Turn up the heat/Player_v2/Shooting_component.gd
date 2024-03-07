extends Controller_component

#region onready

@onready var weapon_sprite = $Visual/Weapon
@onready var muzzle = $Visual/Weapon/Muzzle
@onready var timer_attack_delay = $Timer_attack_delay
@onready var timer_reload = $Timer_reload
@onready var ammo_label = $Visual/AmmoLabel
@onready var reload_progress_bar = $Visual/ReloadProgressBar
#endregion

#region var
var current_weapon: int = 1 
var weapons:Array
var max_clip: int = 0
var clip: int = 0
var second_weapon_clip: int = 0
var is_melee: bool = false
#endregion

#region export var
@export_category("Max stats")
@export var max_ammo: int = 0
@export var max_fuel: int = 0
@export_category("Settings")
@export var is_ammo_enabled: bool = false
@export var is_fuel_enabled: bool = false
@export_category("Current stats")
@export var current_ammo: int = 0
@export var current_fuel: float = 0
#endregion

#region signals
signal on_shoot()
#endregion

func on_ready() -> void:
	weapon_sprite.texture = parent.weapons[0].texture
	get_child(0).reparent(parent)
	weapons = parent.weapons
	clip = weapons[1].clip
	second_weapon_clip = weapons[0].clip
	current_ammo = max_ammo
	current_fuel = max_fuel
	swap_weapon()
	update_magazine_label()

func process_input(event:InputEvent):
	if event.is_action_pressed("swap_weapon"):
		swap_weapon()

func process_physics(delta:float):
	if (Input.is_action_pressed("shoot") and timer_attack_delay.is_stopped() and timer_reload.is_stopped()):
		shoot()
	if (Input.is_action_just_pressed("reload")):
		reload()

func process_frame(delta:float):
	pass

func shoot():
	var weapon: GunData = weapons[current_weapon]
	if clip>=weapon.fire_cost:
		clip -= weapon.fire_cost
		var damage: float = weapon.damage
		var projectiles_count = weapon.projectiles_fired
		var spread = weapon.spread
		for x in projectiles_count:
			var projectile = weapon.projectile.instantiate()
			if not is_melee:
				projectile.max_pierce = weapon.pierce
				projectile.max_bounces = weapon.bounce
			projectile.speed = weapon.bullet_speed
			projectile.max_distance = weapon.bullet_max_distance
			projectile.attack = damage
			projectile.global_position = muzzle.global_position
			if projectiles_count == 1:
				projectile.rotation = weapon_sprite.rotation
			else:
				projectile.rotation = (weapon_sprite.rotation - deg_to_rad(spread/2) + deg_to_rad(spread/(projectiles_count-1)*x))
			parent.get_parent().add_child(projectile)
		timer_attack_delay.start()
	update_magazine_label()
	if clip<weapon.fire_cost:
		reload()

func reload():
	if timer_reload.is_stopped():
		timer_reload.start()

func _on_timer_reload_timeout():
	if is_ammo_enabled:
		current_ammo += clip
		clip = clamp(current_ammo,0,max_clip)
		current_ammo -= clip
	else:
		clip = max_clip
	update_magazine_label()

func swap_weapon():
	timer_reload.stop()
	if current_weapon == 0:
		current_weapon = 1
	else: current_weapon = 0 
	var store: int = clip
	max_clip = weapons[current_weapon].clip
	clip = second_weapon_clip
	second_weapon_clip = store
	weapon_sprite.texture = weapons[current_weapon].texture
	is_melee = weapons[current_weapon].is_melee
	set_timer_reload(weapons[current_weapon].reload_time)
	set_attack_delay_timer(1/weapons[current_weapon].bullets_per_second)
	update_magazine_label()

func set_attack_delay_timer(delay: float):
	timer_attack_delay.wait_time = delay

func set_timer_reload(delay:float):
	timer_reload.wait_time = delay

func update_magazine_label():
	ammo_label.text = str(clip)+"/"+str(max_clip)
