extends Node2D
class_name HealthComponent

@export var Max_health : float = 10.0
@export var text_spread:int = 15

var health: float

func _ready():
	health = Max_health

func damage(attack: float):
	var new_popup = preload("res://UI/damage_popup.tscn").instantiate()
	new_popup.damage_dealt = attack
	new_popup.position = position + Vector2(randf_range(-text_spread,text_spread),randf_range(-text_spread,text_spread))
	get_parent().add_child(new_popup)
	health -= attack
	if health<=0:
		get_parent().queue_free()
