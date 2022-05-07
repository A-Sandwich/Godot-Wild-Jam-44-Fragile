extends "res://Characters/BaseCharacter.gd"

signal arrived
signal reload

var target_location = Vector2.INF
var is_evil = false
var player = null
var can_move = true
var range_attack_cooldown = 2.5
var attack_cooldown = 0.75
var is_lowering = false
var is_rushing = false
var rush_direction = Vector2.ZERO
var rush_speed = speed * 2.75
var agression_increase = 0.5
var agression_level = 0.0
var time_since_last_ranged_attack = 0.0
var time_since_last_charge_attack = 0.0
var basic_attack_info = { "name": "basic", "agression_level": 0.0}
var range_attack_info = { "name": "range", "agression_level": 1.5}
var charge_attack_info = { "name": "charge", "agression_level" : 2.5 }

func _ready():
	$RangedAttackAnimation.play("RESET")
	$AnimatedSprite.play("Idle")
	_turn_evil()
	hp = 10
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
	flip_sprite(direction)
	return direction

func flip_sprite(direction):
	if direction.x < 0:
		emit_signal("flip_h", true)
		$AnimatedSprite.flip_h = true
		$ChargeAttack.flip_h(true)
	elif direction.x > 0:
		emit_signal("flip_h", false)
		$AnimatedSprite.flip_h = false
		$ChargeAttack.flip_h(false)

func update_attack_timers(delta):
	time_since_last_charge_attack += delta
	time_since_last_ranged_attack += delta

func _physics_process(delta):
	update_attack_timers(delta)
	
	if !can_move:
		return
		
	var direction = get_direction(delta)
	
	if !$AnimatedSprite.is_playing():
		$AnimatedSprite.play("Walk")
	move_and_slide(direction * speed)

func get_direction(delta):
	var direction = Vector2.ZERO
	if is_rushing:
		var result = move_and_collide(rush_direction * rush_speed * delta)
		if result or rush_direction == Vector2.ZERO:
			# play bump animation here when ya make it
			rush_direction = get_direction_to_player()
		return

	if is_evil:
		direction = get_direction_to_player()
	else:
		direction = get_direction_to_target()
	return direction
	
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
	
	if direction == null:
		return Vector2.ZERO
	flip_sprite(direction)
	return direction

func attack(direction):
	var distance_to_player = global_position.distance_to(player.global_position)
	if not is_stunned and can_attack:
		most_recent_direction = direction
	var possible_attacks = [basic_attack_info]


func basic_attack(distance_to_player, direction):
	if distance_to_player <= 50:
		emit_signal("attack", direction)
		start_cooldown(attack_cooldown)

func ranged_attack(distance_to_player, direction):
	if agression_level > 1.5 and distance_to_player > 200 and distance_to_player < 400:
		emit_signal("range_attack", direction)
		start_cooldown(range_attack_cooldown)

func charge_attack():
	$Sword.visible = true
	$RangedAttackTimer.stop()
	can_move = false
	can_attack = false
	is_invulnerable = true
	$ChargeAttack/ChargeAttackAnimationPlayer.play("ChargeAttack")

func start_cooldown(attack_cooldown = 1):
	if $AttackCooldown.time_left == 0:
		can_attack = false
		$AttackCooldown.wait_time = attack_cooldown
		$AttackCooldown.start()
	if $MovementCooldown.time_left == 0:
		can_move = false
		$MovementCooldown.start()

func _turn_evil():
	is_evil = true
	$AnimatedSprite.play("IdleEvil")

func _die(animation = "Die"):
	._die("DieEvil")

func _on_MovementCooldown_timeout():
	can_move = true


func _on_AttackCooldown_timeout():
	can_attack = true

func _damage(body):
	._damage(body)
	agression_level += agression_increase
	$AnimatedSprite.play("DamageEvil")
	

func _on_AnimatedSprite_animation_finished():
	pass


func _on_RangedAttackTimer_timeout():
	emit_signal("reload")
	can_move = false
	is_invulnerable = true
	can_attack = false
	$Particles2D.emitting = true
	$LightAnimation.play("IntesifyLight")
	$RangedAttackAnimation.play("RangedAttack")


func _on_RangedAttackAnimation_animation_finished(anim_name):
	if anim_name == "RangedAttack" and !is_lowering:
		$RangedAttackAnimation.play("Bounce")
	elif anim_name == "RangedAttack" and is_lowering:
		is_lowering = false
		can_move = true
		is_invulnerable = false
		can_attack = true
		$Particles2D.emitting = false
		$LightAnimation.play_backwards("IntesifyLight")
		$RangedAttackTimer.start()
		
func is_attacking_range():
	return $RangedAttackAnimation.current_animation == "Bounce" and $RangedAttackAnimation.is_playing()

func _ammo_out():
	$RangedAttackAnimation.play_backwards("RangedAttack")
	is_lowering = true
	


func _on_Charge_animation_finished(anim_name):
	if anim_name == "ChargeAttack":
		$ChargeAttack/ChargeTimer.start()
		$ChargeAttack/ChargeAttackAnimationPlayer.play("Rush")
		can_move = true
		can_attack = true
		is_invulnerable = false
		is_rushing = true


func _on_ChargeTimer_timeout():
	is_invulnerable = false
	is_rushing = false
	$RangedAttackTimer.start()
	$ChargeAttack/ChargeAttackAnimationPlayer.play("RESET")
