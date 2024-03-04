extends Node

func init(parent: CharacterBody2D) -> void:
	for child in get_children():
		child.parent = parent
		child.on_ready()

func process_input(event:InputEvent) -> void:
	for child in get_children():
		child.process_input(event)

func process_physics(delta:float) -> void:
	for child in get_children():
		child.process_physics(delta)
	
func process_frame(delta:float) -> void:
	for child in get_children():
		child.process_frame(delta)
