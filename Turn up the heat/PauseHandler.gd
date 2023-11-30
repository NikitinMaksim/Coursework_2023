extends Node

var is_paused:bool = false

func _ready():
	SignalBus.pause_game.connect(pause)
	SignalBus.unpause_game.connect(unpause)

func _process(_delta):
	if Input.is_action_just_pressed("pause"): 
		if is_paused:
			$"../PauseUI".visible = false
			unpause()
		else:
			$"../PauseUI".visible = true
			pause()

func pause():
	is_paused = true
	$"../Action_UI".modulate = Color(1,1,1,0.5)
	$"..".get_tree().paused = true

func unpause():
	is_paused = false
	$"../Action_UI".modulate = Color(1,1,1,1)
	$"..".get_tree().paused = false
