extends CanvasLayer

func _ready():
	$AnimationPlayer.play("Splash")

func _on_FadeOut_timeout():
	$AnimationPlayer.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene("res://Menus/TitleMenu.tscn")
