extends BoxContainer

var max_ammo_internal:int = 100
var max_fuel_internal:int = 100

func _on_player_set_ammo_ui(ammo):
	$"Grid/Left up corner/Ammo/AmmoLabel".text = str(ammo)+"/"+str(max_ammo_internal)
	$"Grid/Left up corner/Ammo/AmmoBar".value = ammo

func _on_player_set_max_ammo_ui(max_ammo):
	max_ammo_internal = max_ammo
	$"Grid/Left up corner/Ammo/AmmoBar".max_value = max_ammo_internal
	_on_player_set_ammo_ui(max_ammo_internal)

func _on_player_set_fuel_ui(fuel):
	$"Grid/Left up corner/Fuel/FuelLabel".text = str(fuel)+"/"+str(max_fuel_internal)
	$"Grid/Left up corner/Fuel/FuelBar".value = fuel
	if fuel>max_fuel_internal:
		$"Grid/Left up corner/Fuel/FuelLabel".label_settings.set_font_color("#ff4f3e")
	else:
		$"Grid/Left up corner/Fuel/FuelLabel".label_settings.set_font_color("#ffffff")
	if fuel==0:
		$"Grid/Left up corner/Ammo/AmmoLabel".label_settings.set_font_color("#ff4f3e")
	else:
		$"Grid/Left up corner/Ammo/AmmoLabel".label_settings.set_font_color("#ffffff")

func _on_player_set_max_fuel_ui(max_fuel):
	max_fuel_internal = max_fuel
	$"Grid/Left up corner/Fuel/FuelBar".max_value = max_fuel_internal
	_on_player_set_fuel_ui(max_fuel_internal)


func _on_player_set_exp_ui(xp):
	$"Grid/VBoxContainer/Exp bar".value = xp


func _on_player_set_max_exp_ui(max_exp):
	$"Grid/VBoxContainer/Exp bar".max_value = max_exp
