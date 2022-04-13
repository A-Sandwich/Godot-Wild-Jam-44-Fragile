extends Node2D


func _ready():
	$Guy.set_target_location($Center.global_position)

