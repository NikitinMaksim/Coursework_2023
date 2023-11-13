extends Node

var quarters_passed: int = 0
var minutes_passed: int = 0
var points:int=100
var modifier:int=0 

var small_enemy = preload("res://Enemys/Small_enemy/small_enemy.tscn")
var small_enemy_cost = 3
var big_enemy = preload("res://Enemys/Big_enemy/Big_enemy.tscn")
var big_enemy_cost = 1
var range_enemy = preload("res://Enemys/Range_enemy/range_enemy.tscn")
var range_enemy_cost = 1

var number_of_small_enemy: int
var number_of_big_enemy: int
var number_of_range_enemy: int
var total_number_of_enemies: int

var melee_damage_in_minute: float
var range_damage_in_minute: float
var priority: String = "equal"

var amount_of_enemies_spawned_last_minute: int = 0
var amount_of_enemies_killed_last_minute: int = 0

@onready var player = $"../Player"

func _ready():
	$Points_timer.start()
	SignalBus.add_points.connect(Callable(add_points.bind()))
	SignalBus.melee_damage_dealt.connect(Callable(add_melee_damage.bind()))
	SignalBus.range_damage_dealt.connect(Callable(add_range_damage.bind()))
	spawn_enemies()

func add_points(amount):
	points+=amount

func _on_points_timer_timeout():
	quarters_passed += 1
	if quarters_passed == 4:
		quarters_passed = 0
		minutes_passed += 1
		on_minute_passed()
	add_points(minutes_passed*15)
	calculate_number_of_enemies()
	
func calculate_number_of_enemies():
	var points_for_big
	var points_for_range
	if priority == "melee":
		points_for_big = points * 0.35
		points_for_range = points * 0.15
	elif priority == "range":
		points_for_big = points * 0.15
		points_for_range = points * 0.35
	else:
		points_for_big = points * 0.25
		points_for_range = points * 0.25
	number_of_small_enemy = points/2/small_enemy_cost
	number_of_big_enemy = points_for_big/big_enemy_cost
	number_of_range_enemy = points_for_range/range_enemy_cost
	total_number_of_enemies = number_of_small_enemy+number_of_big_enemy+number_of_range_enemy
	$Spawn_timer.wait_time = 15/total_number_of_enemies
	
func spawn_enemies():
	var half_points = points/2
	var rng = RandomNumberGenerator.new()
	while half_points>0:
		var point = rng.randi_range(0,360)
		var spawn_pos = player.global_position+Vector2(1000,0).rotated(deg_to_rad(point))
		half_points -= small_enemy_cost
		var enemy = small_enemy.instantiate()
		enemy.position = spawn_pos
		owner.add_child.call_deferred(enemy)
	
func on_minute_passed():
	if (range_damage_in_minute/melee_damage_in_minute>1.2):
		priority = "melee"
	elif (melee_damage_in_minute/range_damage_in_minute>1.2):
		priority = "range"
	else:
		priority = "equal"
	melee_damage_in_minute = 0
	range_damage_in_minute = 0
	
func add_melee_damage(amount):
	melee_damage_in_minute+=amount
	
func add_range_damage(amount):
	range_damage_in_minute+=amount
