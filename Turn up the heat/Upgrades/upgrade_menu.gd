extends Control

var trees_list:Dictionary={}

const SINGLE_UPGRADE = preload("res://Upgrades/SingleUpgrade.tscn")

func _on_upgrade_system_send_trees(trees):
	trees_list = trees

func _on_upgrade_system_send_upgrades(upgrades):
	for child in $Columns/Upgrades.get_children():
		child.queue_free()
	for upgrade in upgrades:
		var upgrade_visual = SINGLE_UPGRADE.instantiate()
		upgrade_visual.name = upgrade.name
		upgrade_visual.upgrade_name = upgrade.name
		upgrade_visual.descpription = upgrade.description
		upgrade_visual.texture = upgrade.image
		upgrade_visual.tree = upgrade.tree
		upgrade_visual.change_tree.connect(Callable(change_tree))
		$Columns/Upgrades.add_child(upgrade_visual)

func change_tree(tree):
	$Columns/GridContainer/T1Upgrade.texture = trees_list[tree][0].image
	$Columns/GridContainer/T1Upgrade.tooltip_text = trees_list[tree][0].description
	$Columns/GridContainer/T2LUpgrade.texture = trees_list[tree][1].image
	$Columns/GridContainer/T2LUpgrade.tooltip_text = trees_list[tree][1].description
	$Columns/GridContainer/T2RUpgrade.texture = trees_list[tree][2].image
	$Columns/GridContainer/T2RUpgrade.tooltip_text = trees_list[tree][2].description
	$Columns/GridContainer/T3Upgrade.texture = trees_list[tree][3].image
	$Columns/GridContainer/T3Upgrade.tooltip_text = trees_list[tree][3].description
