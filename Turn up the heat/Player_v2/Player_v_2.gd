extends CharacterBody2D

@export var weapons: Array[GunData]
@export var body: BodyData

@onready var animations: AnimationTree =  $AnimationTree
@onready var controller: Node = $Modular_controller

func _ready() -> void:
	controller.init(self)

func _unhandled_input(event:InputEvent) -> void:
	controller.process_input(event)

func _physics_process(delta:float) -> void:
	controller.process_physics(delta)

func _process(delta:float) -> void:
	controller.process_frame(delta)
