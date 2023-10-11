extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	if (rotation_degrees<90 or rotation_degrees>270):
		flip_v = false
		offset.y = -13
	else:
		flip_v = true
		offset.y = -19
	rotation_degrees = wrapf(rotation_degrees, 0, 360)
