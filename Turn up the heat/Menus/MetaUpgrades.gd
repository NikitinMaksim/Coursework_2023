extends Control

const UPGRADE_BUTTON = preload("res://MetaUpgrades/upgrade_button.tscn")
var internalUpgrades: MetaUpgradesStats

func createButtons():
	for child in $MarginContainer/VBoxContainer.get_children():
		child.queue_free()
	var innerupgrades = SingletonDataHolder.get_meta_upgrades().upgrades
	for stat in innerupgrades:
		var button = UPGRADE_BUTTON.instantiate()
		button.set_data(stat, innerupgrades[stat][0],innerupgrades[stat][1],innerupgrades[stat][2],innerupgrades[stat][3])
		button.update_stats.connect(Callable(updateStats.bind()))
		$MarginContainer/VBoxContainer.add_child(button)
	updateStats()

func updateStats():
	$LabelPoints.text = "Points: " + str(SingletonDataHolder.get_meta_upgrades().total_points)

func _on_visibility_changed():
	if visible:
		if ResourceLoader.exists("user://upgrades.tres"):
			SingletonDataHolder.set_meta_upgrades(load("user://upgrades.tres")) 
		else:
			SingletonDataHolder.set_meta_upgrades(load("res://Resources/MetaSaveData.tres"))
		createButtons()

func _on_hide_upgrades_pressed():
	visible = false
	internalUpgrades = SingletonDataHolder.get_meta_upgrades()
	for child in $MarginContainer/VBoxContainer.get_children():
		internalUpgrades.upgrades[child.stat][1] = child.current_upgrades
		internalUpgrades.upgrades[child.stat][3] = child.cost
	print("saving")
	SingletonDataHolder.set_meta_upgrades(internalUpgrades)
	ResourceSaver.save(SingletonDataHolder.get_meta_upgrades(), "user://upgrades.tres")
