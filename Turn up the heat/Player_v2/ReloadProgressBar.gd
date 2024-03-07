extends ProgressBar

@onready var mouse_shooting_component = $"../.."
@onready var timer_reload = $"../../Timer_reload"

func _process(delta):
	if not timer_reload.is_stopped(): 
		max_value = timer_reload.wait_time
		value = max_value - timer_reload.time_left
	else:
		max_value = mouse_shooting_component.max_clip
		value = mouse_shooting_component.clip
