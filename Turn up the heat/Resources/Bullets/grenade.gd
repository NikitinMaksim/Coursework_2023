extends Node2D

@onready var detonation_timer = $DetonationTimer
@onready var explosion_area = $ExplosionArea
@onready var touch_area = $TouchArea

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
	pass # Replace with function body.

#TODO наносит 1/5 урона при столкновении, полный урон по области или когда кончаются пробития и происходит столкновение или когда полностью останавливается
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed*delta
	if (remaining_distance<0 and speed>0): 
		speed = clamp(speed-50,0,speed)
	if speed == 0 and detonation_timer.is_stopped():
		end_of_life()

func _on_touch_area_body_entered(body):
	if body is HitboxComponent:
		var damage = attack/5*(1+ramp_up*0.15)
		body.damage(damage)
	current_pierce -= 1
	if current_pierce<0:
		end_of_life()
		_on_detonation_timer_timeout()

func end_of_life():
	$GPUParticles2D.emitting = true
	$GPUParticles2D.reparent(get_parent())
	detonation_timer.start()

func _on_detonation_timer_timeout():
	for enemy in explosion_area.get_overlapping_bodies():
		if enemy is HitboxComponent:
			var damage = attack*(1+ramp_up*0.15)
			enemy.damage(damage)
	queue_free()
