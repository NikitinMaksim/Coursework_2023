extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.fill_fuel.emit(100)
		SignalBus.fill_ammo.emit(100)
		SignalBus.repair_armor.emit(1)
