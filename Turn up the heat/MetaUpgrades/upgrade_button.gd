extends HBoxContainer

@export var button: Button
@export var label: Label

signal update_stats()

var stat: String = ""
var cost: int = 0
var max_upgrades: int = 0
var current_upgrades: int = 0

func set_data(Stat_name: String, Stat_text: String, StatLevel: int, StatMaxLevel: int, StatCost: int):
	stat = Stat_name
	button.text = Stat_text
	current_upgrades = StatLevel
	max_upgrades = StatMaxLevel
	cost = StatCost
	update_label()

func update_label():
	if current_upgrades<max_upgrades:
		label.text = str(current_upgrades) + "/" + str(max_upgrades) + " " + str(cost)
	else:
		label.text = str(current_upgrades) + "/" + str(max_upgrades) + " Full" 

func _on_button_pressed():
	if SingletonDataHolder.get_remaining_points()>cost and current_upgrades<max_upgrades:
		current_upgrades += 1
		SingletonDataHolder.subtract_points(cost)
		cost *= 2
		update_stats.emit()
		update_label()
