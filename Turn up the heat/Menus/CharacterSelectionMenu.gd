extends Control

@onready var item_list = $ItemList
@onready var character_texture = $CharacterTexture

var character_list: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("res://Resources/Bodys/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var character_import: BodyData = load("res://Resources/Bodys/"+file_name)
			var name = character_import.name
			var atlas = AtlasTexture.new()
			atlas.atlas = character_import.sprite_sheet
			atlas.region = Rect2(0,0,32,32)
			item_list.add_item(name, atlas)
			character_list.append(character_import)
			file_name = dir.get_next()

func _on_item_list_item_selected(index):
	var atlas = AtlasTexture.new()
	atlas.atlas = character_list[index].sprite_sheet
	atlas.region = Rect2(0,0,32,32)
	character_texture.texture = atlas
	var dronetexture = character_list[index].drone.get_state().get_node_property_value(1, 0)
	var atlas2 = AtlasTexture.new()
	atlas2.atlas = dronetexture
	if index == 2:
		atlas2.region = Rect2(0,0,32,32)
	else:
		atlas2.region = Rect2(0,0,24,24)
	$VBoxContainer/DroneContainer/TextureRect.texture = atlas2
