extends CharacterBody2D

var is_moving: bool = false
var speed: int = 300

func _physics_process(delta):
	if is_moving:
		move_and_collide(global_position.direction_to($"../Player".global_position).normalized()*speed*delta)

func _on_area_2d_body_entered(_body):
	SignalBus.fill_fuel.emit(1)
	queue_free()

func _on_magnet_body_entered(body):
	is_moving = true

func _on_magnet_timer_timeout():
	is_moving = true
	speed = 900
