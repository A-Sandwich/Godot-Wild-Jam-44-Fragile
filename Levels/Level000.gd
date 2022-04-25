extends Node2D

var win = false
var can_win = false

func _ready():
	State.level_start()
	var player = State.get_player()
	if player != null:
		get_tree().root.call_deferred("add_child", player)
	for enemy in State.get_slain_enemies():
		call_deferred("add_child", enemy)


func _process(delta):
	if win or not can_win:
		return
	if get_tree().get_nodes_in_group("ghost").size() == 0:
		win = true
		State.level_done()


func _on_WinTimer_timeout():
	can_win = true
