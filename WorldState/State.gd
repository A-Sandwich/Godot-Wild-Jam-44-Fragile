extends Node

var possible_levels = ["res://Levels/Level00.tscn"]
var possible_buff_levels = ["res://Levels/Level000.gd"]
var packed_player = null
var path_taken = []
var packed_levels = []
var level_index = 0
var grid_size = 10
var level_rows = []
var current_level = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var is_new_scene = true

func _ready():
	rng.randomize()
	for y in range(10):
		var col = []
		for x in range(10):
			col.append(-1)
		level_rows.append(col)
	level_rows[0][0] = 0

func buff(buff_name):
	print(buff_name)
	if buff_name == "shield":
		var players= get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			players[0].increase_hp(1)

func save_player(packed_player):
	self.packed_player = null
	self.packed_player = packed_player

func save_direction(direction):
	path_taken.append(direction)

func save_level(level):
	level_rows[current_level.x][current_level.y] = packed_levels.size()
	packed_levels.append(level)

func get_player():
	return packed_player

func connect_win(level):
	for win in get_tree().get_nodes_in_group("win"):
		win.connect("win", level, "_on_win")

func random_level():
	var level = null
	var index = packed_levels.size()
	if rng.randi() % 2 == 0:
		level =  possible_buff_levels[rng.randi_range(0, possible_levels.size() - 1)]
	else:
		level = possible_levels[rng.randi_range(0, possible_levels.size() - 1)]
	return level

func get_next_level_coordinates(direction):
	var new_direction = current_level
	if "North" in direction:
		new_direction.y -= 1
	elif "South" in direction:
		new_direction.y += 1
	elif "East" in direction:
		new_direction.x += 1
	elif "West" in direction:
		new_direction.x -= 1
	current_level = new_direction

func get_next_level(direction):
	get_next_level_coordinates(direction)
	var target_level = level_rows[current_level.x][current_level.y]
	#if target_level == -1:
	#	is_new_scene = false
	#	return get_tree().change_scene(random_level())
	#is_new_scene = true
	return get_tree().change_scene_to(packed_levels[level_rows[current_level.x][current_level.y]])
