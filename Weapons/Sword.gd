extends Node2D

var can_attack = true

func _ready():
	visible = false

func attack(direction):
	if not can_attack:
		return
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
	$Cooldown.start()


func _on_Cooldown_timeout():
	can_attack = true


func _on_AnimationPlayer_animation_started(anim_name):
	visible = true


func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false
