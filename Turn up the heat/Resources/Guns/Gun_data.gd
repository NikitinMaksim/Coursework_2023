extends Resource
class_name GunData

@export var is_melee: bool = false
@export var damage: float = 0
@export var clip: int = 0
@export var fire_cost: int = 1
@export var bullets_per_second: float = 0
@export var reload_time: float = 0
@export var spread: float = 0
@export var projectiles_fired: int = 1
@export var pierce: int = 0
@export var bounce: int = 0
@export var texture: Texture2D
@export var projectile: PackedScene
@export var x_offset: int = 0
@export var bullet_speed: int = 450
@export var bullet_max_distance: int = 20000
