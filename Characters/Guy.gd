extends Node2D

func _ready():
	pass

func set_target_location(target_location):
	$KinematicBody2D.target_location = target_location
