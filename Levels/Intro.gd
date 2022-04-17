extends Node2D

signal arrived
var ENEMY = preload("res://Characters/Enemy.tscn")
var game_started = false
var animation_played = false

func _ready():
	var player = State.get_player()
	player.global_position = Vector2(-65, -1)
	add_child(player)
	State.level_start()
	if get_tree().get_nodes_in_group("guy").size() > 0:
		$Guy.set_target_location($Center.global_position)
		$Guy.connect("arrived", self, "_on_arrival")
		$Player.player_controlled = false
	for enemy in State.get_slain_enemies():
		add_child(enemy)

func _on_arrival():
	if $Center.global_position.distance_to($Guy/KinematicBody2D.global_position) < 10:
		var new_dialog = Dialogic.start('/Intro')
		new_dialog.connect("timeline_end", self, "_on_timeline_end")
		add_child(new_dialog)
	else:
		$Guy.visible = false
		var enemy = ENEMY.instance()
		enemy.global_position = $End.global_position
		get_tree().root.add_child(enemy)
		$Guy.queue_free()
		$Door.start()
		$Player.player_controlled = true
		game_started = true

func _on_timeline_end(timeline_name):
	$Guy.set_target_location($End.global_position)


func _on_Door_timeout():
	for spike in get_tree().get_nodes_in_group("spike"):
		spike.engage()

func _process(delta):
	if game_started:
		state_check()

func state_check():
	if animation_played:
		return
	var win = true
	var lose = false
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.is_alive:
			win = false
	for player in get_tree().get_nodes_in_group("player"):
		lose = not player.is_alive
	
	if lose:
		pass

	if win:
		State.level_done()
		animation_played = true
