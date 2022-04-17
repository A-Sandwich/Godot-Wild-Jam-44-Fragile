extends Node2D

var win = false
var can_win = false

func _ready():
	var player = State.get_player()
	if player != null:
		add_child(player)
	var enemies = State.get_enemies()
	for enemy in enemies:
		yield(get_tree().create_timer(0.1), "timeout")
		add_child(enemy)
	for enemy in State.get_slain_enemies():
		add_child(enemy)
	State.level_start()

func _process(delta):
	if win or not can_win:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")
	var are_all_enemies_dead = true
	for enemy in enemies:
		if enemy.is_alive:
			are_all_enemies_dead = false
			break

	if are_all_enemies_dead or enemies.size() == 0:
		win = true
		State.level_done()


func _on_WinTimeout_timeout():
	can_win = true
