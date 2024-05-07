extends Node

var gun1: GunData
var gun2: GunData
var character: BodyData
var metaupgrades: MetaUpgradesStats

func set_gun1(gun):
	gun1 = gun

func set_gun2(gun):
	gun2 = gun

func set_body(body):
	character = body

func get_gun1():
	return gun1

func get_gun2():
	return gun2

func get_body():
	return character

func set_meta_upgrades(stats):
	metaupgrades = stats

func get_meta_upgrades():
	return metaupgrades
