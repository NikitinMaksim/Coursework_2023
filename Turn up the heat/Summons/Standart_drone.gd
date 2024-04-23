extends Node2D

@export var target: Node2D

var d = 0
var speed: int = 2
var radius: int = 300

func _ready():
	$AnimationPlayer.active = true
	$AnimationPlayer.current_animation = "Idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d+=delta
	position = (Vector2(sin(d*speed)*radius,cos(d*speed)*radius)+target.global_position)
