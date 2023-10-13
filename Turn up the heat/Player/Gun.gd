extends Sprite2D

@onready var marker_2d = $Marker2D
@onready var player = $".."
var x_offset: int = 0
var y_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if (rotation_degrees<90 or rotation_degrees>270):
		flip_v = false
		offset.y = -13
		marker_2d.position.y = y_offset
	else:
		flip_v = true
		offset.y = -19
		marker_2d.position.y = -y_offset
	rotation_degrees = wrapf(rotation_degrees, 0, 360)


func _on_player_change_offset(x, y):
	marker_2d.position.x = x
	y_offset = y
