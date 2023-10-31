extends CharacterBody2D

@onready var friend_zone = $FriendZone
@onready var friend_finder = $FriendFinder
@onready var too_close = $TooClose

@export var stats: EnemyData

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
	var target
	var direction
	var closest_friend
	var distance_to_closest: float = 99999999999999999
	if (close):
		var vectorAway: Vector2
		for friend in close:
			vectorAway -= global_position.direction_to(friend.global_position).normalized()
		direction =  vectorAway.normalized()
	elif (friends_nearby) and (friends.size()==0):
		for friend in friends_nearby:
			var distance = global_position.distance_to(friend.global_position)
			if distance_to_closest>distance:
				distance_to_closest = distance
				closest_friend = friend
		target = closest_friend
		direction = global_position.direction_to(target.global_position).normalized()
	else:
		target = get_node("../Player")
		direction =  global_position.direction_to(target.global_position).normalized()
	move_and_collide(direction*stats.speed*delta)
