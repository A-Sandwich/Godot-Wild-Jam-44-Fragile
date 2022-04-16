extends Node2D


func _ready():
	pass

func light():
	$AnimatedSprite.play("Light")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Light":
		$AnimatedSprite.play("Burn")


func _on_Timer_timeout():
	$Light2D.visible = true


func _on_StarterTimer_timeout():
	light()
	$Timer.start()
