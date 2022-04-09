extends Node2D

var can_attack = true

func _ready():
	visible = false

func attack(direction):
	if not can_attack:
		return
	print("Attack")
	$Cooldown.start()
	can_attack = false
	if direction.x > 0:
		if direction.y == 0:
			$AnimationPlayer.play("SwingRight")
		elif direction.y != 0:
			$AnimationPlayer.play("SwingRightFull")
	elif direction.x < 0:
		if direction.y == 0:
			$AnimationPlayer.play("SwingLeft")
		elif direction.y != 0:
			$AnimationPlayer.play("SwingLeftFull")
	elif direction.y > 0:
		$AnimationPlayer.play("SwingDown")
	else:
		$AnimationPlayer.play("SwingUp")


func _on_Cooldown_timeout():
	can_attack = true


func _on_AnimationPlayer_animation_started(anim_name):
	visible = true


func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false


func _on_Area2D_body_entered(body):
	if body == self or body == get_parent():
		return
	if body.has_method("die"):
		body.die()


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if "SwordArea" in area.name:
		get_parent().parry(false)
		area.owner.get_parent().parry(true)
