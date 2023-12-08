extends Node
class_name Upgrade

@export var Info: UpgradeInfo

func OnTake():
	for Child in $"../StashedUpgrades".get_children():
		if Child.Info.tree == Info.tree:
			if Info.tier == 1:
				if Child.Info.tier==2 or Child.Info.tier==3:
					Child.reparent(get_parent())
			if Info.tier == 2 or Info.tier==3:
				if Child.Info.tier==4:
					Child.reparent(get_parent())

	for stat in Info.stats:
		if typeof(Info.stats[stat])==TYPE_INT:
			if Info.stats[stat]!=0:
				SignalBus.modify_player_stats.emit(stat,Info.stats[stat])
		else:
			if Info.stats[stat]!=false:
				SignalBus.modify_player_stats.emit(stat,Info.stats[stat])
