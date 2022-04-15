extends Node2D


func _ready():
	var new_dialog = Dialogic.start('/Buffs/Buff-Intro')
	new_dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(new_dialog)

func _on_timeline_end(timeline):
	$Ghost.die()
