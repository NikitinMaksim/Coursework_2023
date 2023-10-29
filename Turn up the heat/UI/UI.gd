extends VBoxContainer

var max_ammo_internal:int = 100
var max_fuel_internal:int = 100

func _on_player_set_ammo_ui(ammo):
	$Ammo/AmmoLabel.text = str(ammo)+"/"+str(max_ammo_internal)
	$Ammo/AmmoBar.value = ammo

func _on_player_set_max_ammo_ui(max_ammo):
	max_ammo_internal = max_ammo
	$Ammo/AmmoBar.max_value = max_ammo_internal
	_on_player_set_ammo_ui(max_ammo_internal)

func _on_player_set_fuel_ui(fuel):
	$Fuel/FuelLabel.text = str(fuel)+"/"+str(max_fuel_internal)
	$Fuel/FuelBar.value = fuel
	if fuel>max_fuel_internal:
		$Fuel/FuelLabel.label_settings.set_font_color("#ff4f3e")
	else:
		$Fuel/FuelLabel.label_settings.set_font_color("#ffffff")
	if fuel==0:
		$Ammo/AmmoLabel.label_settings.set_font_color("#ff4f3e")
	else:
		$Ammo/AmmoLabel.label_settings.set_font_color("#ffffff")

func _on_player_set_max_fuel_ui(max_fuel):
	max_fuel_internal = max_fuel
	$Fuel/FuelBar.max_value = max_fuel_internal
	_on_player_set_fuel_ui(max_fuel_internal)
