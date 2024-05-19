extends Node2D

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
	#$GPUParticles2D.emitting = true


func _on_touch_area_body_entered(body):
	pass # Replace with function body.
