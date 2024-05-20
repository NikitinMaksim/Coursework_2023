extends Node2D

@export var max_distance: int = 700
@export var speed: int = 100
@export var attack: float
@onready var linger_timer = $LingerTimer

var remaining_distance: int = 100

func _ready():
	remaining_distance = max_distance

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed*delta
	if (remaining_distance<0 and speed>0): 
		speed = clamp(speed-50,0,speed)
	if speed == 0 and linger_timer.is_stopped():
		linger_timer.start()

func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		area.damage(attack)
		SignalBus.melee_damage_dealt.emit(attack)
	if area.get_parent().is_in_group("enemy_projectile"):
		area.get_parent().queue_free()

func _on_linger_timer_timeout():
	queue_free()
