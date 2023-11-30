extends Node

var upgrades_available: Dictionary = {}
var upgrades_stashed: Dictionary = {}

func _ready():
	for child in get_children():
		if child is Upgrade:
			upgrades_available[child.name] = child

func take_upgrade(upgrade_name):
	upgrades_available[upgrade_name].OnTake()
