extends Node2D

var FIREBALL = preload("res://Weapons/FireBall.tscn")
var target_node = null
var can_attack = true
var angle = 0.0

func _ready():
	get_parent().connect("range_attack", self, "_attack")

func set_target_node(target):
	target_node = target

func _attack(direction):
	if !can_attack:
		return

	setup_cooldown()

	direction = get_direction(direction)

	create_fireball(direction)

func create_fireball(direction):
	var fireball = FIREBALL.instance()
	fireball.global_position = get_parent().global_position
	fireball.direction = direction
	fireball.radians = get_parent().global_position.angle_to(direction)
	fireball.rotate(get_parent().global_position.angle_to(direction))
	get_tree().root.add_child(fireball)

func get_direction(direction):
	if target_node != null:
		direction = global_position.direction_to(target_node.global_position)
	return direction

func setup_cooldown():
	can_attack = false
	$Cooldown.start()

func _on_Cooldown_timeout():
	can_attack = true

func die():
	queue_free()
