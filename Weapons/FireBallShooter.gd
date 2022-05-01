extends Node2D

signal ammo_out

var FIREBALL = preload("res://Weapons/FireBall.tscn")
var target_node = null
var can_attack = true
var angle = 0.0
var shot_capacity = 5
var number_of_shots = shot_capacity

func _ready():
	get_parent().connect("range_attack", self, "_attack")
	$SpawnPoints.connect_flip_signal(get_parent())
	connect("ammo_out", get_parent(), "_ammo_out")

func set_target_node(target):
	target_node = target

func _attack(direction):
	if !can_attack:
		return

	setup_cooldown()

	var spawn_point = get_spawn_point()

	if spawn_point == null:
		return

	direction = get_direction(direction, spawn_point)

	create_fireball(direction, spawn_point)

func get_spawn_point():
	var spawn_point = $SpawnPoints.get_point()
	if spawn_point != null:
		number_of_shots -= 1
		if number_of_shots == 0:
			emit_signal("ammo_out")
	return spawn_point

func create_fireball(direction, spawn_point):
	var fireball = FIREBALL.instance()
	fireball.global_position = spawn_point.global_position
	fireball.direction = direction
	fireball.radians = spawn_point.global_position.angle_to(direction)
	fireball.rotate(spawn_point.global_position.angle_to(direction))
	get_tree().root.add_child(fireball)
	spawn_point._setup(fireball)

func get_direction(direction, spawn_point):
	if target_node != null:
		direction = spawn_point.global_position.direction_to(target_node.global_position)
	return direction


func setup_cooldown():
	can_attack = false
	$Cooldown.start()

func _on_Cooldown_timeout():
	can_attack = true

func die():
	queue_free()
