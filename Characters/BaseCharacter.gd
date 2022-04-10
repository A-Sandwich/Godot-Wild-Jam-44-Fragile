extends KinematicBody2D

var SHATTERSPRITE = preload("res://Libs/ShatterSprite.tscn")
var is_alive = true
var is_parrying = false

func _ready():
	pass


func attack(direction):
	for child in get_children():
		if child.is_in_group("weapon"):
			child.attack(direction)

func die():
	if is_parrying:
		is_parrying = false
		return
	for child in get_children():
		if child is AnimatedSprite:
			is_alive = false
			child.stop()
			child.play("Die")


func parry(is_disabled):
	if not is_in_group("player"):
		yield(get_tree().create_timer(1), "timeout")
	else:
		var is_parrying = true
