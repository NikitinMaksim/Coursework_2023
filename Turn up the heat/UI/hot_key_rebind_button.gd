class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name: String = "move_left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"move_left":
			label.text = "Move left"
		"move_right":
			label.text = "Move right"
		"move_up":
			label.text = "Move up"
		"move_down":
			label.text = "Move down"
		"swap_weapon":
			label.text = "Swap weapon"
		"reload":
			label.text = "Reload"
		"LevelUp":
			label.text = "Level up"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = "%s" % action_keycode

func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press any key"
		set_process_unhandled_key_input(toggled_on)
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
		get_tree().get_first_node_in_group("exitbutton").disabled = true
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()
		get_tree().get_first_node_in_group("exitbutton").disabled = false

func _unhandled_key_input(event):
	if not event.is_action("pause"):
		rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event)->void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name,event)
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
