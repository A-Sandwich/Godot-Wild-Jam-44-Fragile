extends Node2D


func _ready():
	pass

func light():
	$AnimatedSprite.play("Light")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Light":
		$Light2D.visible = true
		$AnimatedSprite.play("Burn")

