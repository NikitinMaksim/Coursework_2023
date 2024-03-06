extends Controller_component

var max_ammo: int = 0

func process_input(event:InputEvent):
	pass

func process_physics(delta:float):
	pass

func process_frame(delta:float):
	pass

func on_ready():
	var max_ammo: int = parent.body.max_ammo
	print(max_ammo)
