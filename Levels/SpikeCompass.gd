extends Node2D


func _ready():
	State.connect("level_done", self, "_on_level_done")

func _on_level_done():
	$StartGameDetection.stop_monitoring()
