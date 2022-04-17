extends Node2D


func _ready():
	State.connect("light_fire", self, "light_fires")

func light_fires():
	for child in get_children():
		if child.has_method("light"):
			child.light()
