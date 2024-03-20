extends Node2D
class_name HealthComponent

@export var max_health : float = 10.0
@export var text_spread: int = 15
@export var health: float

func damage(attack: float):
	var new_popup = preload("res://UI/damage_popup.tscn").instantiate()
	new_popup.damage_dealt = attack
	new_popup.position = global_position + Vector2(randf_range(-text_spread,text_spread),randf_range(-text_spread,text_spread))
	new_popup.scale = Vector2(2,2)
	get_parent().get_parent().add_child(new_popup)
	health -= attack
	if health<=0:
		get_parent().queue_free()
