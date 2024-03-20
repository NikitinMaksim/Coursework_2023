extends CharacterBody2D

@onready var friend_finder: Node = $FriendFinder
@onready var too_close: Node = $TooClose
@onready var player: Node = get_node("../Player")
@onready var shoot_cooldown: Node = $ShootCooldown

var projectile = preload("res://Enemies/Range_enemy/Ball.tscn")

@export var stats: EnemyData
@export var is_knocked_back: bool = false

signal knockback()

func _ready():
	$HealthComponent.max_health = stats.health
	$HealthComponent.health = stats.health

func _physics_process(delta):
	var stop: bool = false
	var friends_nearby = friend_finder.get_overlapping_bodies()
	friends_nearby.erase($HitboxComponent)
	var close = too_close.get_overlapping_bodies()
	close.erase($HitboxComponent)
	close.erase(get_node("../Player"))
	var direction
	if (close):
		var vectorAway: Vector2 = global_position.direction_to(player.global_position)
		for friend in close:
			vectorAway -= global_position.direction_to(friend.global_position)
		direction =  vectorAway.normalized()
		stop=false
	elif (global_position.distance_to(player.global_position)<900):
		if shoot_cooldown.is_stopped():
			shoot_cooldown.start()
			var ball = projectile.instantiate()
			ball.damage = stats.damage
			ball.rotation = get_angle_to(player.global_position)
			ball.global_position = global_position
			add_sibling(ball)
			stop=true
		else:
			direction = Vector2(0,0)
	else:
		stop=false
		direction =  global_position.direction_to(player.global_position).normalized()
	if is_knocked_back:
		stop = false
		if $KnockBack.is_stopped():
			$KnockBack.start()
		direction =  global_position.direction_to(player.global_position).normalized() * -6
	if !stop:
		if direction.x > 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		move_and_collide(direction*stats.speed*delta)

func collision(body):
	if body.is_in_group("player"):
		$KnockBack.start()
		is_knocked_back = true
		SignalBus.player_hurt.emit(stats.damage)

func _on_knock_back_timeout():
	is_knocked_back = false


func _on_tree_exiting():
	SignalBus.enemy_died.emit(global_position,stats)
