extends Node

var quarters_passed: int = 0
var minutes_passed: int = 0
var points:int=60

var small_enemy = preload("res://Enemies/Small_enemy/small_enemy.tscn")
var small_enemy_cost: int = 2
var big_enemy = preload("res://Enemies/Big_enemy/Big_enemy.tscn")
var big_enemy_cost: int = 20
var range_enemy = preload("res://Enemies/Range_enemy/range_enemy.tscn")
var range_enemy_cost: int = 20

var number_of_small_enemy: int
var number_of_big_enemy: int
var number_of_range_enemy: int
var total_number_of_enemies: int

var melee_damage_in_minute: float
var range_damage_in_minute: float
var priority: String = "equal"

var amount_of_enemies_spawned_last_minute: int = 0
var amount_of_enemies_killed_last_minute: int = 0

@onready var player: Node = $"../Player"

func _ready():
	$Points_timer.start()
	SignalBus.add_points.connect(Callable(add_points.bind()))
	SignalBus.melee_damage_dealt.connect(Callable(add_melee_damage.bind()))
	SignalBus.range_damage_dealt.connect(Callable(add_range_damage.bind()))
	SignalBus.enemy_died.connect(Callable(enemy_killed.bind()))
	calculate_number_of_enemies()
	spawn_enemies()

func add_points(amount):
	points+=amount

func _on_points_timer_timeout():
	var modifier: float = 1
	var armor_priority: int = 1
	var ammo_priority:int = 1
	var fuel_priority: int = 1
	var nothing: int = 4
	var rng = RandomNumberGenerator.new()
	quarters_passed += 1
	if quarters_passed == 4:
		quarters_passed = 0
		minutes_passed += 1
		on_minute_passed()
	add_points((minutes_passed+2)*15)
	if amount_of_enemies_killed_last_minute>0 and amount_of_enemies_spawned_last_minute>0:
		if amount_of_enemies_spawned_last_minute/amount_of_enemies_killed_last_minute>1.2:
			modifier += 0.15
		elif amount_of_enemies_spawned_last_minute/amount_of_enemies_killed_last_minute<0.8:
			modifier -= 0.15
	if player.current_fuel>0:
		if player.max_fuel/player.current_fuel>0.8:
			modifier += 0.10
		elif player.max_fuel/player.current_fuel<0.2:
			modifier -= 0.05
			fuel_priority = 2
	if player.current_ammo>0:
		if player.max_ammo/player.current_ammo>0.8:
			modifier += 0.10
		elif player.max_ammo/player.current_ammo<0.2:
			modifier -= 0.05
			ammo_priority = 2
	var roll = rng.randi_range(1,armor_priority+ammo_priority+fuel_priority+nothing)
	var point = rng.randi_range(0,360)
	var spawn_pos = player.global_position+Vector2(300,0).rotated(deg_to_rad(point))
	if roll>armor_priority+ammo_priority+fuel_priority:
		if nothing>0:
			nothing-=1
	elif roll>armor_priority+ammo_priority:
		var drop = preload("res://Drops/Fuel_drop.tscn").instantiate()
		drop.position = spawn_pos
		owner.add_child(drop)
		nothing+=1
	elif roll>armor_priority:
		var drop = preload("res://Drops/Ammo_drop.tscn").instantiate()
		drop.position = spawn_pos
		owner.add_child(drop)
		nothing+=1
	else:
		var drop = preload("res://Drops/Armor_drop.tscn").instantiate()
		drop.position = spawn_pos
		owner.add_child(drop)
		nothing+=1
	points = points*(1+modifier)
	calculate_number_of_enemies()
	
func calculate_number_of_enemies():
	var points_for_big: float
	var points_for_range: float
	if minutes_passed>1:
		points_for_big = points * 0.25
		number_of_big_enemy = points_for_big/big_enemy_cost
		number_of_small_enemy = points/4*3/small_enemy_cost
	elif minutes_passed>3:
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
	else:
		number_of_small_enemy = points/small_enemy_cost
		number_of_big_enemy = 0
		number_of_range_enemy = 0
	total_number_of_enemies = number_of_small_enemy+number_of_big_enemy+number_of_range_enemy
	points = 0
	$Spawn_timer.wait_time = 15/float(total_number_of_enemies)
	
func spawn_enemies():
	var rng = RandomNumberGenerator.new()
	if total_number_of_enemies>0:
		var point: int = rng.randi_range(0,360)
		var spawn_pos: Vector2 = player.global_position+Vector2(2000,0).rotated(deg_to_rad(point))
		var who_to_spawn = roll_for_enemy()
		var enemy: CharacterBody2D
		if who_to_spawn == "small_enemy":
			enemy = small_enemy.instantiate()
		elif who_to_spawn == "big_enemy":
			enemy = big_enemy.instantiate()
		elif who_to_spawn == "range_enemy":
			enemy = range_enemy.instantiate()
		if enemy:
			amount_of_enemies_spawned_last_minute+=1
			enemy.position = spawn_pos
			get_owner().add_child.call_deferred(enemy)
		
func roll_for_enemy():
	var rng = RandomNumberGenerator.new()
	var random_spawn: int = rng.randi_range(1,3)
	if random_spawn==1 and number_of_small_enemy>0:
		return "small_enemy"
	elif random_spawn==2 and number_of_big_enemy>0:
		return "big_enemy"
	elif random_spawn==3 and number_of_range_enemy>0:
		return "range_enemy"
	elif total_number_of_enemies==0:
		return "none"
	else:
		roll_for_enemy()
		
func on_minute_passed():
	if minutes_passed==5:
		$"../CanvasLayer/Loss_win_menu".visible = true
		SignalBus.win.emit()
		SignalBus.pause_game.emit()
	if (range_damage_in_minute/melee_damage_in_minute>1.2):
		priority = "melee"
	elif (melee_damage_in_minute/range_damage_in_minute>1.2):
		priority = "range"
	else:
		priority = "equal"
	amount_of_enemies_spawned_last_minute = 0
	amount_of_enemies_killed_last_minute = 0
	melee_damage_in_minute = 0
	range_damage_in_minute = 0
	
func add_melee_damage(amount):
	melee_damage_in_minute+=amount
	
func add_range_damage(amount):
	range_damage_in_minute+=amount

func enemy_killed(Where:Vector2, stats):
	amount_of_enemies_killed_last_minute+=1
	var expOrb = preload("res://Enemies/ExpOrb.tscn").instantiate()
	expOrb.position = Where
	expOrb.exp_drop = stats.exp_drop
	owner.add_child.call_deferred(expOrb)
