extends Node2D

@export var target: Node2D

func _process(delta):
	if target != null:
		look_at(target.global_position)
		var distance = global_position.distance_to(target.global_position)
		if distance>150:
			$Sprite2D.offset = Vector2(clamp(distance/10,20,30),0)
	else: queue_free()
	if (rotation_degrees<90 or rotation_degrees>270):
		$Sprite2D.flip_v = false
	else:
		$Sprite2D.flip_v = true
	rotation_degrees = wrapf(rotation_degrees, 0, 360)
