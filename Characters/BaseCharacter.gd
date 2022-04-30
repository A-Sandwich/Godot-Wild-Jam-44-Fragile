extends KinematicBody2D

var SHATTERSPRITE = preload("res://Libs/ShatterSprite.tscn")
var is_alive = true
var speed = 150
var knockback = Vector2.ZERO
var hp = 1
var most_recent_direction = Vector2.ZERO
var is_invulnerable = false
var is_stunned = false
var can_attack = false

signal attack

func _ready():
	add_to_group("damageable")
	detect_darkness()

func detect_darkness():
	if get_tree().get_nodes_in_group("darkness").size() > 0 and is_alive:
		$Light2D.visible = true
	else:
		$Light2D.visible = false


func attack(direction):
	for child in get_children():
		if child.is_in_group("weapon"):
			child.attack(direction)

func _die(animation = "Die"):
	is_alive = false
	for child in get_children():
		if child is AnimatedSprite:
			is_alive = false
			child.stop()
			child.play(animation) 
		if child.is_in_group("weapon"):
			child.die()
	$Light2D.visible = false
	$DeathNoise.play()

func _damage(body):
	if self != body or is_invulnerable:
		return
	if "Player" in name:
		print(hp)
	knockback = most_recent_direction * -1
	hp -= 1
	if hp == 0:
		_die()

func _parry(direction):
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
