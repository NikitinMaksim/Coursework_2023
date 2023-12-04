extends HBoxContainer

var armor = preload("res://UI/Armor/armor_plate.tscn")

func setArmor(max_armor:int):
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	for i in range(max_armor):
		var health = armor.instantiate()
		self.add_child(health)
