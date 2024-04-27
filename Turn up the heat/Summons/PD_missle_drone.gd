extends Node2D

#Rotation data
@export var orbit_target: Node2D
var d = 0
var speed: int = 2
var radius: int = 300

#Enemy selection data
var enemies: Array = []
@onready var enemy_finder = $EnemyFinder
var shooting_target: Node2D

#Shooting data
@onready var shoot_timer = $Shoot_timer
@onready var timer_reload = $Timer_reload
@onready var gun = $GunSprite
@export var weapon: GunData
var clip
var modifiers = {
	"damage":0,
	"attack_speed":0,
	"pierce":0,
	"magazine_size":0,
	"bounce":0,
	"projectile":0,
	"spread":0
}

func _ready():
	$AnimationPlayer.active = true
	$AnimationPlayer.current_animation = "Idle"
	gun.texture = weapon.texture
	shoot_timer.wait_time = 1/weapon.bullets_per_second
	clip = weapon.clip

func _process(delta):
	d+=delta
	position = (Vector2(sin(d*speed)*radius,cos(d*speed)*radius)+orbit_target.global_position)
	if is_instance_valid(shooting_target):
		gun.look_at(shooting_target.global_position)

func _on_enemy_finder_body_entered(area):
	enemies.append(area)
	if enemies.size()==1:
		shooting_target = area
	else: 
		var closest = enemies[0]
		for enemy in enemies:
			if global_position.distance_squared_to(enemy.global_position)<global_position.distance_squared_to(closest.global_position):
				closest = enemy
		shooting_target = closest
	if shoot_timer.is_stopped():
		shoot_timer.start()

func _on_enemy_finder_body_exited(area):
	enemies.erase(area)
	if enemies.size()==0 and not is_instance_valid(shooting_target):
		shoot_timer.stop()

func _on_shoot_timer_timeout():
	if is_instance_valid(shooting_target):
		var damage: float = weapon.damage*(1+(float(modifiers["damage"])/100))
		clip -= weapon.fire_cost
		var projectiles_count = weapon.projectiles_fired+modifiers["projectile"]
		for x in projectiles_count:
			var projectile = weapon.projectile.instantiate()
			var spread = weapon.spread+modifiers["spread"]
			if (weapon.is_melee):
				pass
			else:
				projectile.max_pierce = weapon.pierce+modifiers["pierce"]
				projectile.max_bounces = weapon.bounce+modifiers["bounce"]
			projectile.speed = weapon.bullet_speed
			projectile.max_distance = weapon.bullet_max_distance
			projectile.attack = damage
			projectile.global_position = gun.global_position
			if projectiles_count == 1:
				projectile.rotation = gun.rotation
			else:
				projectile.rotation = (gun.rotation - deg_to_rad(spread/2) + deg_to_rad(spread/(projectiles_count-1)*x))
			projectile.target = shooting_target
			owner.add_child(projectile)
		enemies.erase(shooting_target)
		SoundBus.play_shoot_sound()
		if clip<=0:
			reload()

func reload():
	if timer_reload.is_stopped():
		timer_reload.start()

func _on_timer_reload_timeout():
	clip = weapon.clip
