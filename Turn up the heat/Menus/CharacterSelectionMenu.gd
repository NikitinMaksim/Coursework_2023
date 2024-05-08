extends Control

@onready var char_list = $CharacterList
@onready var character_texture = $CharacterTexture
@onready var weapon_list_1 = $WeaponList1
@onready var weapon_list_2 = $WeaponList2

var character_list: Array
var selectedbody: int = 0

var gunslist: Array
var selectedgun: int = 0

var meleelist: Array
var selectedmelee: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("res://Resources/Bodys/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var character_import: BodyData = load("res://Resources/Bodys/"+file_name)
			var char_name = character_import.name
			var atlas = AtlasTexture.new()
			atlas.atlas = character_import.sprite_sheet
			atlas.region = Rect2(0,0,32,32)
			char_list.add_item(char_name, atlas)
			character_list.append(character_import)
			file_name = dir.get_next()
	var dirweapons = DirAccess.open("res://Resources/Guns/PlayerGuns/")
	if dirweapons:
		dirweapons.list_dir_begin()
		var file_name = dirweapons.get_next()
		while file_name != "":
			var weapon_import: GunData = load("res://Resources/Guns/PlayerGuns/"+file_name)
			var weapon_name = weapon_import.name
			var weapon_sprite = weapon_import.texture
			if weapon_import.is_melee:
				weapon_list_2.add_item(weapon_name,weapon_sprite)
				meleelist.append(weapon_import)
			else:
				weapon_list_1.add_item(weapon_name,weapon_sprite)
				gunslist.append(weapon_import)
			file_name = dirweapons.get_next()
	char_list.select(0)
	_on_item_list_item_selected(0)
	weapon_list_1.select(0)
	weapon_list_2.select(0)

func _on_item_list_item_selected(index):
	selectedbody = index
	var character = character_list[index]
	var atlas = AtlasTexture.new()
	atlas.atlas = character.sprite_sheet
	atlas.region = Rect2(0,0,32,32)
	character_texture.texture = atlas
	var dronetexture = character.drone.get_state().get_node_property_value(1, 0)
	var atlas2 = AtlasTexture.new()
	atlas2.atlas = dronetexture
	if index == 2:
		atlas2.region = Rect2(0,0,32,32)
	else:
		atlas2.region = Rect2(0,0,24,24)
	$VBoxContainer/DroneContainer/TextureRect.texture = atlas2
	$VBoxContainer/DroneContainer/Label.text = character.drone_description
	$VBoxContainer/ArmorContainer/Label.text = "Health: " + str(character.armor_platings)
	$VBoxContainer/SpeedContainer/Label.text = "Speed: " + str(character.speed)
	$VBoxContainer/MaxAmmoContainer/Label.text = "Max ammo: " + str(character.max_ammo)
	$VBoxContainer/MaxFuelContainer/Label.text = "Max fuel: " + str(character.max_fuel)

func _on_start_game_pressed():
	SingletonDataHolder.set_body(character_list[selectedbody])
	SingletonDataHolder.set_gun1(gunslist[selectedgun])
	SingletonDataHolder.set_gun2(meleelist[selectedmelee])
	if SingletonDataHolder.metaupgrades == null:
		if ResourceLoader.exists("user://upgrades.tres"):
			SingletonDataHolder.set_meta_upgrades(load("user://upgrades.tres")) 
		else:
			SingletonDataHolder.set_meta_upgrades(load("res://Resources/MetaSaveData.tres"))
	get_tree().change_scene_to_file("res://Main_scene.tscn")

func _on_weapon_list_1_item_selected(index):
	selectedgun = index

func _on_weapon_list_2_item_selected(index):
	selectedmelee = index

func _on_button_pressed():
	$MetaUpgrades.visible = true

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
