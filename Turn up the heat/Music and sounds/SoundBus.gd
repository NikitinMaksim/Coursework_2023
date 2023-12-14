extends Node

@onready var music = $Music
@onready var shoot_sound = $ShootSound
@onready var enemy_death_sound = $EnemyDeathSound
@onready var reload_sound = $ReloadSound

func play_die_sound():
	enemy_death_sound.play()

func play_shoot_sound():
	shoot_sound.play()

func play_reload_sound():
	reload_sound.play()

func _on_music_finished():
	music.play()
