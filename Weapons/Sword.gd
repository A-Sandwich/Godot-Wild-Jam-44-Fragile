extends Node2D

var can_attack = true
var attack_hits = []

func _ready():
	visible = false

func attack(direction):
	if not can_attack:
		return
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
	attack_hits.clear()
	visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false
	var parent = get_parent()

func _on_Area2D_body_entered(body):
	if body == self or body == get_parent():
		return
	if not body in attack_hits:
		attack_hits.append(body)
		if body.has_method("die"):
			body.die()

func _on_Parry_area_entered(area):
	if not $AnimationPlayer.is_playing():
		return
	if area != $Sprite/SwordArea and not "Parry" in area.name and "SwordArea" in area.name:
		parry(true) 
		area.owner.parry(false)


func parry(playAudio):
	if playAudio:
		$AudioStreamPlayer2D.play()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
