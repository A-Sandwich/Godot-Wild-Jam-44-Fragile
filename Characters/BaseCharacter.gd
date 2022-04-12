extends KinematicBody2D

var SHATTERSPRITE = preload("res://Libs/ShatterSprite.tscn")
var is_alive = true

func _ready():
	pass


func attack(direction):
	for child in get_children():
		if child.is_in_group("weapon"):
			child.attack(direction)

func die():
	is_alive = false
	yield(get_tree().create_timer(1), "timeout")
	if is_alive:
		print("Not dead")
		return
	for child in get_children():
		if child is AnimatedSprite:
			is_alive = false
			child.stop()
			child.play("Die")
		if child.is_in_group("weapon"):
			child.die()


func parry():
	is_alive = true
