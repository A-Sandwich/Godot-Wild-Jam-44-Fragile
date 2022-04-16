extends Node2D

signal damage

var can_attack = true
var attack_speed = 2.0
var previous_direction = Vector2.ZERO

func _ready():
	get_parent().connect("attack", self, "_attack")
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
			$AnimationPlayer.play("RightFull", -1, attack_speed)
		elif direction.y < 0:
			$AnimationPlayer.play("UpRightFull", -1, attack_speed)
		else:
			$AnimationPlayer.play("DownRightFull", -1, attack_speed)
	elif direction.x < 0:
		if direction.y == 0:
			$AnimationPlayer.play("LeftFull", -1, attack_speed)
		elif direction.y < 0:
			$AnimationPlayer.play("UpLeftFull", -1, attack_speed)
		else:
			$AnimationPlayer.play("DownLeftFull", -1, attack_speed)
	elif direction.y > 0:
		$AnimationPlayer.play("DownFull", -1, attack_speed)
	else:
		$AnimationPlayer.play("UpFull", -1, attack_speed)


func _on_Cooldown_timeout():
	can_attack = true

func die():
	$AnimationPlayer.stop()
	$AudioStreamPlayer2D.stop()
	$Sprite.visible = false


func _on_Area2D_body_entered(body):
	print(body.name)
	if body == self or body == get_parent():
		return
	if not is_connected("damage", body, "_damage"):
		connect("damage", body, "_damage")
	emit_signal("damage", body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "RESET":
		$AnimationPlayer.play("RESET")


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name != "RESET":
		$AudioStreamPlayer2D.play()
