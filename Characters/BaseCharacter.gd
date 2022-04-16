extends KinematicBody2D

var SHATTERSPRITE = preload("res://Libs/ShatterSprite.tscn")
var is_alive = true
var speed = 150
var knockback = Vector2.ZERO
var hp = 1

signal attack

func _ready():
	add_to_group("damageable")


func attack(direction):
	for child in get_children():
		if child.is_in_group("weapon"):
			child.attack(direction)

func _die():
	print("die", name)
	is_alive = false
	for child in get_children():
		print(child is AnimatedSprite)
		if child is AnimatedSprite:
			print("dying")
			is_alive = false
			child.stop()
			child.play("Die") 
		if child.is_in_group("weapon"):
			child.die()


func _damage(body):
	if self != body:
		return
	hp -= 1
	if hp == 0:
		_die()

func _parry(direction):
	print("parry", name)
	is_alive = true
	for child in get_children():
		if child is AnimatedSprite:
			child.stop()
			child.play("Idle")
	knockback = direction * -1

func _knocback():
	var result = knockback
	if knockback != Vector2.ZERO:
		result = knockback * (speed)
	return result
