extends "res://Characters/BaseCharacter.gd"

var player = null
var stunned = false
var can_attack = false

func _ready():
	._ready()
	speed = State.rng.randi_range(75, 129)
	$Sword.attack_speed = 0.5
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _physics_process(delta):
	if not is_alive:
		return

	var direction = global_position.direction_to(player.global_position)
	var knockback = _knocback()
	if knockback != Vector2.ZERO:
		if $Pushback.time_left == 0:
			$Pushback.start()
		move_and_slide(knockback)
	elif not stunned:
		if can_attack and global_position.distance_to(player.global_position) <= 32:
			emit_signal("attack", direction)
		most_recent_direction = direction
		move_and_slide(direction * speed)

func _parry(direction):
	._parry(direction)
	$Stunned.start()
	stunned = true

func _on_Pushback_timeout():
	knockback = Vector2.ZERO


func _on_Stunned_timeout():
	stunned = false

func _die():
	._die()
	$CollisionShape2D.queue_free()
	$Sword.queue_free()


func _on_InitialCooldown_timeout():
	can_attack = true


func _on_InitialCooldown_tree_entered():
	detect_darkness()

func _damage(body):
	._damage(body)
