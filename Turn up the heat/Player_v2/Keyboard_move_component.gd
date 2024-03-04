extends Controller_component

func process_input(event:InputEvent):
	pass

func process_physics(delta:float):
	var direction: Vector2 = Vector2(0,0)
	var velocity: Vector2 = Vector2(0,0)
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		parent.velocity = direction * (parent.body.speed)
	else:
		parent.velocity = Vector2.ZERO
	parent.move_and_slide()

func process_frame(delta:float):
	pass
