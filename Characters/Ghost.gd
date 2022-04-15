extends Node2D


func _ready():
	$AnimatedSprite.play("Default2")

func die():
	$AnimatedSprite.play("Die")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Die":
		queue_free()
