extends Node

var quarters_passed: int = 0
var minutes_passed: int = 0
var points:float=0

func _ready():
	$Points_timer.start()
	SignalBus.add_points.connect(Callable(add_points.bind()))

func add_points(amount):
	points+=amount

func _on_points_timer_timeout():
	quarters_passed += 1
	if quarters_passed == 4:
		quarters_passed = 0
		minutes_passed += 1
	add_points(minutes_passed*15)
