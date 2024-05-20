extends Node2D

@onready var detonation_timer = $DetonationTimer
@onready var explosion_area = $ExplosionArea

@export var speed: int = 750
var start_speed: int = 0
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
	detonation_timer.stop()
	detonation_timer.wait_time = 0.1
	if is_timer_active:
		$InvisTimer.start()
	start_speed = speed

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed*delta
	if (remaining_distance<0 and speed>0): 
		speed = clamp(speed-50,0,speed)
	if speed == 0 and detonation_timer.is_stopped():
		start_explosion()
		detonation_timer.start()

func start_explosion():
	if is_instance_valid($GPUParticles2D):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.reparent(get_parent())

func _on_detonation_timer_timeout():
	for enemy in explosion_area.get_overlapping_bodies():
		if enemy is HitboxComponent:
			var damage = attack*(1+ramp_up*0.15)
			enemy.damage(damage)
		elif enemy.get_parent().is_in_group("enemy_projectile"):
			enemy.get_parent().queue_free()
	queue_free()
