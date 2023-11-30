extends Node

var is_paused:bool = false

func _ready():
	SignalBus.pause_game.connect(pause)

func _process(_delta):
	if Input.is_action_just_pressed("pause"): 
		pause()

func pause():
	is_paused = !is_paused
	if is_paused: 
		$"../PauseUI".visible = true
		$"../Action_UI".modulate = Color(1,1,1,0.5)
	else:
		$"../PauseUI".visible = false
		$"../Action_UI".modulate = Color(1,1,1,1)
	$"..".get_tree().paused = !$"..".get_tree().paused
