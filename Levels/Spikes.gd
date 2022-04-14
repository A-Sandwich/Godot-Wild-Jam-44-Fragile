extends Node2D


func _ready():
	pass

func engage():
	$AnimatedSprite.play("default")

func disengage():
	$AnimatedSprite.play("default", true)

func _on_AnimatedSprite_animation_finished():
	$Area2D.monitorable = true


func _on_Area2D_body_entered(body):
	if body.has_method("_damage") and $AnimatedSprite.frame == 3:
		body._damage(body)
