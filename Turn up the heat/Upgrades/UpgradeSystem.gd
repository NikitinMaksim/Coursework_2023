extends Node

var upgrades_available: Dictionary = {}
var upgrades_to_spend: int = 0
var trees: Dictionary = {}

const upgradescript = preload("res://Upgrades/Upgrade.gd")

signal hide_lvlup_notif()
signal add_upgrade_tree(array)

func _process(_delta):
	if Input.is_action_just_pressed("LevelUp") and upgrades_to_spend>0:
		level_up()

func _ready():
	#TODO
	#Перед запуском 
	#Cкомпилировать все деревья апгрейдов и отправить в UpgradeUI для ускорения отрисовки во время игры
	var dir = DirAccess.open("res://Upgrades/Upgrades_Stats/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var node = Node.new()
			node.set_script(upgradescript)
			var stats_import = load("res://Upgrades/Upgrades_Stats/"+file_name)
			node.Info = stats_import
			node.name = node.Info.name
			if node.Info.tier>1:
				$StashedUpgrades.add_child(node)
			else:
				add_child(node)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	ListAvailableUpgrades()
	CompileTrees()

func ListAvailableUpgrades():
	upgrades_available.clear()
	for child in get_children():
		if child is Upgrade:
			upgrades_available[child.name] = child

func CompileTrees():
	var all_upgrades: Array=[]
	for upgrade in get_children():
		if upgrade is Upgrade:
			all_upgrades.append(upgrade.Info)
	for upgrade in $StashedUpgrades.get_children():
		if upgrade is Upgrade:
			all_upgrades.append(upgrade.Info)
	for upgrade in all_upgrades:
		if trees.has(upgrade.tree):
			trees[upgrade.tree].append(upgrade)
		else:
			trees[upgrade.tree] = Array()
			trees[upgrade.tree].append(upgrade)
			

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
