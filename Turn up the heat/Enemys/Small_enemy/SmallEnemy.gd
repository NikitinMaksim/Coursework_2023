extends CharacterBody2D

@onready var friend_zone = $FriendZone
@onready var friend_finder = $FriendFinder
@onready var too_close = $TooClose
@onready var player = get_node("../Player")

@export var stats: EnemyData
@export var is_knocked_back: bool = false

signal knockback()

func _ready():
	$HealthComponent.max_health = stats.health
	$HealthComponent.health = stats.health

func _physics_process(delta):
	
	var friends = friend_zone.get_overlapping_bodies()
	friends.erase($HitboxComponent)
	var friends_nearby = friend_finder.get_overlapping_bodies()
	friends_nearby.erase($HitboxComponent)
	var close = too_close.get_overlapping_bodies()
	close.erase($HitboxComponent)
	close.erase(get_node("../Player"))
	var direction: Vector2
	if (close):
		var vectorAway: Vector2 = global_position.direction_to(player.global_position)
		for friend in close:
			vectorAway -= global_position.direction_to(friend.global_position)
		direction =  vectorAway.normalized()
	elif (friends_nearby) and (friends.size()==0):
		var futhest_friend
		var distance_to_furthest: float = 0
		for friend in friends_nearby:
			var distance = global_position.distance_to(friend.global_position)
			if distance_to_furthest<distance:
				distance_to_furthest = distance
				futhest_friend = friend
		direction = global_position.direction_to(futhest_friend.global_position).normalized()
	else:
		var vector: Vector2 = Vector2(0,0)
		if friends_nearby.size()>0:
			for friend in friends_nearby:
				vector += global_position.direction_to(friend.global_position).normalized()
		direction =  global_position.direction_to(player.global_position-vector.normalized()).normalized()
	if is_knocked_back:
		if $KnockBack.is_stopped():
			$KnockBack.start()
		direction =  global_position.direction_to(player.global_position).normalized() * -6
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
