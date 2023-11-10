extends Node

var quarters_passed: int = 0
var minutes_passed: int = 0
var points:int=100
var modifier:int=0
var spawn_radius = Vector2(1000,0)

var small_enemy = preload("res://Enemys/Small_enemy/small_enemy.tscn")
var small_enemy_cost = 3
var big_enemy = preload("res://Enemys/Big_enemy/Big_enemy.tscn")
var big_enemy_cost = 1
var range_enemy = preload("res://Enemys/Range_enemy/range_enemy.tscn")
var range_enemy_cost = 1

var amount_of_enemies_spawned_last_minute: int = 0
var amount_of_enemies_killed_last_minute: int = 0

@onready var player = $"../Player"

func _ready():
	$Points_timer.start()
	SignalBus.add_points.connect(Callable(add_points.bind()))
	spawn_enemies()

func add_points(amount):
	points+=amount

func _on_points_timer_timeout():
	quarters_passed += 1
	if quarters_passed == 4:
		quarters_passed = 0
		minutes_passed += 1
	add_points(minutes_passed*15)
	spawn_enemies()
	
func spawn_enemies():
	var half_points = points/2
	var rng = RandomNumberGenerator.new()
	while half_points>0:
		var point = rng.randi_range(0,360)
		var spawn_pos = player.global_position+spawn_radius.rotated(deg_to_rad(point))
		half_points -= small_enemy_cost
		var enemy = small_enemy.instantiate()
		enemy.position = spawn_pos
		owner.add_child.call_deferred(enemy)
	
