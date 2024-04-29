extends Node2D

@onready var sprite = $Sprite2D

func _ready():
	sprite.frame = randi_range(0,2)
	SignalBus.ore_spawned.emit(self)

func _on_tree_exiting():
	var points = randi_range(15,25)
	SignalBus.add_meta_points.emit(points)
	var new_popup = preload("res://MetaUpgrades/points_popup.tscn").instantiate()
	new_popup.points = points
	new_popup.position = global_position
	new_popup.scale = Vector2(2,2)
	get_parent().get_parent().add_child.call_deferred(new_popup)
