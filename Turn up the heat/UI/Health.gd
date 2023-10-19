extends HBoxContainer


func setArmor(max:int):
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	for i in range(max):
		var armor = preload("res://UI/armor_plate.tscn").instantiate()
		self.add_child(armor)