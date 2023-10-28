extends CharacterBody2D
class_name HitboxComponent

@export var health_component : HealthComponent

func damage(attack:float):
	if health_component:
		health_component.damage(attack)
