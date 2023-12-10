extends Node

func _on_child_exiting_tree(node):
	SignalBus.enemy_died.emit(node.Global_position, node.stats)
