extends Node2D


func _ready():
	visible = false
	$Area2D.monitoring = false

func winnable():
	visible = true
	$Area2D.monitoring = true

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene("res://Levels/Level00.tscn")
