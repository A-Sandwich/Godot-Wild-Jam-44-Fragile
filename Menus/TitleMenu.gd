extends CanvasLayer


func _ready():
	$AnimationPlayer.play("Intro")


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Levels/Level00.tscn")
