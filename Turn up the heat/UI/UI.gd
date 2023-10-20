extends VBoxContainer

var max_ammo_internal:int = 100

func _on_player_set_ammo_ui(ammo):
	$Ammo/Label.text = str(ammo)+"/"+str(max_ammo_internal)
	$Ammo/TextureProgressBar.value = ammo

func _on_player_set_max_ammo_ui(max_ammo):
	max_ammo_internal = max_ammo
	$Ammo/TextureProgressBar.max_value = max_ammo_internal
	_on_player_set_ammo_ui(max_ammo_internal)
