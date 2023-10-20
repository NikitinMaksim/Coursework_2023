extends HBoxContainer


func setArmor(max_armor:int):
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	for i in range(max_armor):
		var armor = preload("res://UI/armor/armor_plate.tscn").instantiate()
		self.add_child(armor)
