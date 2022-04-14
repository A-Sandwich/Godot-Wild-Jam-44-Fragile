extends Node2D

signal arrived

func _ready():
	$KinematicBody2D.connect("arrived", self, "_on_arrived")

func set_target_location(target_location):
	$KinematicBody2D.target_location = target_location
	$KinematicBody2D/AnimatedSprite.play()

func _on_arrived():
	emit_signal("arrived")
