extends Node2D


func _ready():
	var player = State.get_player()
	if player != null:
		player.global_position = Vector2(100, 100)
		get_tree().root.add_child(player)
	var new_dialog = Dialogic.start('/Buffs/Buff-Intro')
	new_dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(new_dialog)

func _on_timeline_end(timeline):
	$Ghost.die()
