extends ProgressBar

@onready var timer_reload = $"../../Timer_reload"
@onready var player = $"../.."

func _process(_delta):
	if not timer_reload.is_stopped(): 
		max_value = timer_reload.wait_time
		value = max_value - timer_reload.time_left
	else:
		max_value = player.max_clip
		value = player.clip
