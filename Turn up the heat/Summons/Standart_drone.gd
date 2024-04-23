extends Node2D

@export var target: Node2D
@export var weapon: GunData
var d = 0
var speed: int = 2
var radius: int = 300

func _ready():
	$AnimationPlayer.active = true
	$AnimationPlayer.current_animation = "Idle"

func _process(delta):
	d+=delta
	position = (Vector2(sin(d*speed)*radius,cos(d*speed)*radius)+target.global_position)
	#TODO перенести сюда код стрельбы использя GunData
