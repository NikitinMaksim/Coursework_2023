extends Node
class_name Upgrade

@export var Info: UpgradeInfo
@export var ChildUpgrades: Array[Upgrade]

func OnTake():
	for Child in ChildUpgrades:
		if Child in $"../StashedUpgrades".get_children():
			Child.reparent(get_parent())
	for stat in Info.stats:
		if typeof(Info.stats[stat])==TYPE_INT:
			if Info.stats[stat]!=0:
				SignalBus.modify_player_stats.emit(stat,Info.stats[stat])
		else:
			if Info.stats[stat]!=false:
				SignalBus.modify_player_stats.emit(stat,Info.stats[stat])
