extends "res://Characters/BaseCharacter.gd"

signal arrived

var target_location = Vector2.INF
var is_evil = false
var player = null

func _ready():
	$AnimatedSprite.play("Idle")
	hp = 10

func set_target_location(target):
	target_location = target
	$AnimatedSprite.play("Walk")

func get_direction_to_target():		
	if global_position.distance_to(target_location) < 5:
		target_location = Vector2.INF
		emit_signal("arrived")

	if target_location == Vector2.INF:
		$AnimatedSprite.stop()
		return Vector2.ZERO
	
	var direction = global_position.direction_to(target_location)
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite.flip_h = false
		
	return direction

func get_direction_to_player():
	pass

func _physics_process(delta):
	var direction = Vector2.ZERO
	if is_evil:
		direction = get_direction_to_player()
	else:
		direction = get_direction_to_target()

	move_and_slide(direction * speed)

func get_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0]
	return null

func attack_player():
	if not is_alive:
		return
	
	if not player:
		player = get_player()

	var direction = global_position.direction_to(player.global_position)
	var knockback = _knocback()
	if knockback != Vector2.ZERO:
		if $Pushback.time_left == 0:
			$Pushback.start()
		move_and_slide(knockback)
	elif not is_stunned:
		if can_attack and global_position.distance_to(player.global_position) <= 32:
			emit_signal("attack", direction)
		most_recent_direction = direction
		move_and_slide(direction * speed)

func _turn_evil():
	$AnimatedSprite.play("IdleEvil")
