extends Node

var upgrades_available: Dictionary = {}
var upgrades_to_spend: int = 0

signal hide_lvlup_notif()

func _process(_delta):
	#if Input.is_action_just_pressed("LevelUp") and upgrades_to_spend>0:
		#level_up()
	if Input.is_action_just_pressed("LevelUp"):
		take_upgrade("Damage_1")
		take_upgrade("Damage_2")
		take_upgrade("Damage_3")

func _ready():
	#TODO
	#Перед запуском скомпилировать все деревья апгрейдов и отправить в UpgradeUI для ускорения отрисовки во время игры
	ListAvailableUpgrades()

func ListAvailableUpgrades():
	upgrades_available.clear()
	for child in get_children():
		if child is Upgrade:
			upgrades_available[child.name] = child

func level_up():
	hide_lvlup_notif.emit()
	#TODO
	#Выбрать 2(Или 3) апгрейда случайным образом, передать их в UpgradeUI
	#В UpgradeUI выставить три апгрейда и вернуть выбранный

func take_upgrade(upgrade_name):
	upgrades_to_spend -= 1
	upgrades_available[upgrade_name].OnTake()
	upgrades_available[upgrade_name].reparent($TakenUpgrades)
	ListAvailableUpgrades()

func _on_player_level_up():
	upgrades_to_spend += 1
