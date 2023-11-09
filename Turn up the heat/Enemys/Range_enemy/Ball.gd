extends Node2D

@export var speed: int = 50
@export var max_distance: int = 20000
@export var damage: int = 1

var remaining_distance: int = 100

func _ready():
	remaining_distance = max_distance

func _process(delta):
	position += transform.x * speed * delta
	remaining_distance -= speed
	if (remaining_distance<0): 
		queue_free()

func _on_area_2d_body_entered(body):
	SignalBus.player_hurt.emit(damage)
	queue_free()
