extends "res://Characters/BaseCharacter.gd"

signal arrived

var target_location = Vector2.INF
var is_evil = false
var player = null
var is_cooling = false

func _ready():
	$AnimatedSprite.play("Idle")
	_turn_evil()
	#hp = 10
	speed = 50
	$Sword.scale = scale * .75
	$Sword._update_cooldown(2)
	$Sword._update_attack_speed(0.2)
	yield(get_tree().create_timer(1), "timeout")
	can_attack = true

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


func _physics_process(delta):
	if is_cooling:
		return

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

func get_direction_to_player():
	if not is_alive:
		return Vector2.ZERO
	
	if not player:
		player = get_player()
		if player == null:
			return Vector2.ZERO

	var direction = global_position.direction_to(player.global_position)
	var knockback = _knocback()
	
	if not is_stunned:
		if can_attack:
			var distance_to_player = global_position.distance_to(player.global_position)
			if distance_to_player > 200 and distance_to_player < 400:
				emit_signal("range_attack", direction)
				start_cooldown()
			elif distance_to_player <= 100:
				emit_signal("attack", direction)
				start_cooldown()
		most_recent_direction = direction
	
	if direction == null:
		return Vector2.ZERO
	return direction

func start_cooldown():
	is_cooling = true
	$ActionCooldown.start()

func _turn_evil():
	is_evil = true
	$AnimatedSprite.play("IdleEvil")


func _on_ActionCooldown_timeout():
	is_cooling = false

func _die(animation = "Die"):
	._die("DieEvil")
