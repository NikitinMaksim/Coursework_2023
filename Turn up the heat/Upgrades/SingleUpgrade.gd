extends VBoxContainer

@export var upgrade_name: String
@export var descpription: String
@export var texture: Texture2D
@export var tree: String

signal change_tree(upgrade_tree)

func _ready():
	$TextureRect.texture = texture
	$UpgradeName.text = upgrade_name
	$UpgradeDescription.text = descpription

func _on_mouse_entered():
	modulate=Color("a9a9a9")
	change_tree.emit(tree)

func _on_mouse_exited():
	modulate=Color("ffffff")

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		SignalBus.take_upgrade.emit($UpgradeName.text)
