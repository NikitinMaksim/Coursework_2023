extends Resource

class_name MetaUpgradesStats

@export var total_points: int = 0
@export var upgrades: Dictionary = {
	"damage": ["Damage",0,3,50,10],
	"armor": ["Armor",0,3,50,1],
	"speed": ["Speed",0,3,50,5],
	"projectile": ["Projectile",0,3,150,1],
	"max_ammo": ["Max Ammo",0,3,100,10],
	"max_fuel": ["Max Fuel",0,3,100,10]
}
