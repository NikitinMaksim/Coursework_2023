extends CharacterBody2D

var speed: int = 300
var is_moving = false
@export var exp_drop: int = 1

func _physics_process(delta):
	if is_moving:
		move_and_collide(global_position.direction_to($"../Player".global_position).normalized()*speed*delta)

func _on_area_2d_body_entered(_body):
	is_moving = true
	$GPUParticles2D.emitting = true


func _on_area_2d_2_body_entered(_body):
	SignalBus.add_exp.emit(exp_drop)
	queue_free()
