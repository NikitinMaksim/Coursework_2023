extends Resource

class_name MetaUpgradesStats

#First number - current level, second - max level, third - cost for next level
@export var total_points: int = 0
@export var upgrades: Dictionary = {
	"damage": ["Damage",0,3,50],
	"armor": ["Armor",0,3,50],
	"speed": ["Speed",0,3,50],
	"projectile": ["Projectile",0,3,150],
	"max_ammo": ["Max Ammo",0,3,100],
	"max_fuel": ["Max Fuel",0,3,100]
}
