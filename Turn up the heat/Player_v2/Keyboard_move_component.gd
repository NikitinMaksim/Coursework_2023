extends Controller_component

var direction : Vector2 = Vector2.ZERO

func process_input(event:InputEvent):
	pass

func process_physics(delta:float):
	var velocity: Vector2 = Vector2.ZERO
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		parent.velocity = direction * 300 * delta * parent.body.speed
	else:
		parent.velocity = Vector2.ZERO
	parent.move_and_slide()

func process_frame(delta:float):
	if (direction == Vector2.ZERO):
		parent.animations["parameters/conditions/is_idle"] = true
		parent.animations["parameters/conditions/is_walking"] = false
	else:
		parent.animations["parameters/conditions/is_idle"] = false
		parent.animations["parameters/conditions/is_walking"] = true
		parent.animations["parameters/Idle/blend_position"] = direction
		parent.animations["parameters/Walk/blend_position"] = direction
