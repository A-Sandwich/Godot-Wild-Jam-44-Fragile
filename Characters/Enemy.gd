extends "res://Characters/BaseCharacter.gd"

var player = null
var stunned = false

func _ready():
	speed = 100
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
		if global_position.distance_to(player.global_position) <= 32:
			emit_signal("attack", direction)
		move_and_slide(direction * speed)

func _parry(direction):
	._parry(direction)
	$Stunned.start()
	stunned = true

func _on_Pushback_timeout():
	knockback = Vector2.ZERO
	$AnimatedSprite.play("Damage")


func _on_Stunned_timeout():
	stunned = false
