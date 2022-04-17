extends Node2D

var can_attack = true
var previous_direction = Vector2.ZERO
var attack_speed = 1.0

signal parry
signal damage

func _ready():
	visible = false
	get_parent().connect("attack", self, "_attack")
	connect("parry", get_parent(), "_parry")
	for damageable in get_tree().get_nodes_in_group("damageable"):
		connect("damage", damageable, "_damage")
	
func _attack(direction):
	if not can_attack:
		return
	previous_direction = direction
	$Cooldown.start()
	can_attack = false
	if direction.x > 0:
		if direction.y == 0:
			$AnimationPlayer.play("SwingRight", -1, attack_speed)
		elif direction.y != 0:
			$AnimationPlayer.play("SwingRightFull", -1, attack_speed)
	elif direction.x < 0:
		if direction.y == 0:
			$AnimationPlayer.play("SwingLeft", -1, attack_speed)
		elif direction.y != 0:
			$AnimationPlayer.play("SwingLeftFull", -1, attack_speed)
	elif direction.y > 0:
		$AnimationPlayer.play("SwingDown", -1, attack_speed)
	else:
		$AnimationPlayer.play("SwingUp", -1, attack_speed)


func _on_Cooldown_timeout():
	can_attack = true


func _on_AnimationPlayer_animation_started(anim_name):
	visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false
	var parent = get_parent()

func _on_Parry_area_entered(area):
	if not $AnimationPlayer.is_playing():
		return
	if area != self and "Parry" in area.name:
		parry(true)

func parry(playAudio):
	emit_signal("parry", previous_direction)
	if playAudio:
		$AudioStreamPlayer2D.play()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")

func die():
	$AnimationPlayer.stop()
	$AudioStreamPlayer2D.stop()
	$Parry.set_deferred("monitorable", false)
	$Parry.set_deferred("monitoring", false)


func _on_Parry_body_entered(body):
	if body == self or body == get_parent():
		return
	$Parry/ParryTimer.start()
	if not is_connected("damage", body, "_damage"):
		connect("damage", body, "_damage")
	emit_signal("damage", body)

