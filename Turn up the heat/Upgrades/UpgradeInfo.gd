extends Resource
class_name UpgradeInfo

@export var image: Texture2D
@export var name: String
@export var tree: String
@export var tier: int
@export_multiline var description: String
@export var stats = {
	"damage":0,
	"attack_speed":0,
	"pierce":0,
	"max_ammo":0,
	"magazine_size":0,
	"bounce":0,
	"projectile":0,
	"spread":0,
	"max_fuel":0,
	"speed":0,
	"armor":0,
	"is_split_active":false,
	"is_backwards_fire_active":false,
	"is_rampup_active":false,
	"is_armor_crafting_active":false,
	"is_rage_active":false,
	"is_armor_to_damage_active":false,
	"is_ammo_crafting_active":false,
	"is_fuel_drops_active":false
}
