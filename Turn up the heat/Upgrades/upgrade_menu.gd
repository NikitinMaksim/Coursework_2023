extends Control

var trees_list:Dictionary={}

func _on_upgrade_system_send_trees(trees):
	trees_list = trees
