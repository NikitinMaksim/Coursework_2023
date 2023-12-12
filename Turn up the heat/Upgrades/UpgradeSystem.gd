extends Node

var upgrades_available: Dictionary = {}
var upgrades_to_spend: int = 0
var trees: Dictionary = {}

const upgradescript = preload("res://Upgrades/Upgrade.gd")

signal hide_lvlup_notif()
signal send_trees(trees)
signal send_upgrades(upgrades)
signal show_lvlup_notif()

func _process(_delta):
	if Input.is_action_just_pressed("LevelUp") and upgrades_to_spend>0 and upgrades_available.size()>0:
		level_up()

func _ready():
	SignalBus.take_upgrade.connect(Callable(take_upgrade))
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
	send_trees.emit(trees)

func level_up():
	var rng = RandomNumberGenerator.new()
	var first_upgrade = rng.randi_range(0,upgrades_available.size()-1)
	var second_upgrade = rng.randi_range(0,upgrades_available.size()-1)
	var third_upgrade = rng.randi_range(0,upgrades_available.size()-1)
	if upgrades_available.size()>1:
		while first_upgrade==second_upgrade:
			second_upgrade = rng.randi_range(0,upgrades_available.size()-1)
		if upgrades_available.size()>2:
			while third_upgrade==first_upgrade or third_upgrade==second_upgrade:
				third_upgrade = rng.randi_range(0,upgrades_available.size()-1)
	var upgrades: Array = []
	if upgrades_available.size()>0:
		upgrades.append(upgrades_available.values()[first_upgrade].Info)
	if upgrades_available.size()>1:
		upgrades.append(upgrades_available.values()[second_upgrade].Info)
		if upgrades_available.size()>2:
			upgrades.append(upgrades_available.values()[third_upgrade].Info)
	send_upgrades.emit(upgrades)

func take_upgrade(upgrade_name):
	upgrades_to_spend -= 1
	if upgrades_to_spend<1:
		hide_lvlup_notif.emit()
	upgrades_available[upgrade_name].OnTake()
	upgrades_available[upgrade_name].reparent($TakenUpgrades)
	ListAvailableUpgrades()

func _on_player_level_up():
	upgrades_to_spend += 1
	if upgrades_available.size()>0:
		show_lvlup_notif.emit()
