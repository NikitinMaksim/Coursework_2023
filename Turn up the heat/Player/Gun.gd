extends Sprite2D

@onready var marker_2d = $Marker2D
@onready var player = $".."
var x_offset: int = 0

func _process(_delta):
	look_at(get_global_mouse_position())
	if (rotation_degrees<90 or rotation_degrees>270):
		flip_v = false
	else:
		flip_v = true
	rotation_degrees = wrapf(rotation_degrees, 0, 360)
