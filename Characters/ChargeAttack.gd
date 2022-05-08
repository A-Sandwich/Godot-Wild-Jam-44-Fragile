extends Node2D

var flip_h = false

func _ready():
	pass

func flip_h(flip):
	flip_h = flip

func _on_ChargeAttackAnimationPlayer_animation_finished(anim_name):
	if "Rush" in anim_name:
		if flip_h:
			$ChargeAttackAnimationPlayer.play("RushLeft")
		else:
			$ChargeAttackAnimationPlayer.play("Rush")
