extends ProgressBar
@onready var timer_reload = $"../../Timer_reload"
@onready var player = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer_reload.is_stopped(): 
		max_value = timer_reload.wait_time
		value = max_value - timer_reload.time_left
	else:
		max_value = player.max_clip
		value = player.clip
