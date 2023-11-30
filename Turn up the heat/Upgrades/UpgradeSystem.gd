extends Node

var upgrades_available: Dictionary = {}
var upgrades_stashed: Dictionary = {}
var upgrades_to_spend: int = 0

signal hide_lvlup_notif()

func _process(delta):
	if Input.is_action_just_pressed("LevelUp") and upgrades_to_spend>0:
		level_up()

func _ready():
	for child in get_children():
		if child is Upgrade:
			upgrades_available[child.name] = child

#Сделать добавление новых улучшений при выборе через reparent, дописать интерфейс улучшений, сделать тестовые спрайты

func level_up():
	hide_lvlup_notif.emit()

func take_upgrade(upgrade_name):
	upgrades_to_spend -= 1
	upgrades_available[upgrade_name].OnTake()

func _on_player_level_up():
	upgrades_to_spend += 1
