extends Node2D

signal damage

var can_attack = true
var attack_speed = 2.0
var previous_direction = Vector2.ZERO

func _ready():
	get_parent().connect("attack", self, "_attack")
	get_parent().connect("stop_attack", self, "_stop_attack")
	for damageable in get_tree().get_nodes_in_group("damageable"):
		connect("damage", damageable, "_damage")
	
	disable_sword()

func _update_cooldown(value):
	$Cooldown.wait_time = value

func _update_attack_speed(value):
	attack_speed = value

func _attack(direction):
	if not can_attack:
		return
	previous_direction = direction
	$Cooldown.start()
	can_attack = false
	visible = true
	set_deferred("$Sprite/Area2D.monitoring", true)
	set_deferred("$Sprite/Area2D.monitorable", true)
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
	if body == self or body == get_parent():
		return
	if "enemy" in get_parent().get_groups() and "enemy" in body.get_groups():
		return
	if not is_connected("damage", body, "_damage") and "damagable" in body.get_groups():
		connect("damage", body, "_damage")
	print(body.name)
	emit_signal("damage", body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "RESET":
		$AnimationPlayer.play("RESET")
		disable_sword()

func disable_sword():
	visible = false
	set_deferred("$Sprite/Area2D.monitoring", false)
	set_deferred("$Sprite/Area2D.monitorable", false)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name != "RESET":
		$AudioStreamPlayer2D.play()

func _stop_attack():
	disable_sword()
