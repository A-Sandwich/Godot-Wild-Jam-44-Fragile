extends Node

signal win
signal level_done
signal level_start
signal light_fire

var PLAYER = preload("res://Characters/Player.tscn")
var ENEMY = preload("res://Characters/Enemy.tscn")
var possible_levels = ["res://Levels/Level00.tscn"]
var possible_buff_levels = ["res://Levels/Level000.tscn"]
var possible_buff_dialogues = ["/Buffs/Buff001", "/Buffs/Buff002"]
var packed_player = null
var path_taken = []
var level_index = 0
var grid_size = 10
var level_rows = []
var current_level = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var is_new_scene = true
var number_of_enemies = 1
var default_player_location = Vector2(25,25)
var default_enemy_location = Vector2(100,100)
var default_location = Vector2(50,75)
var slain_enemies = []

func _ready():
	rng.randomize()
	for y in range(10):
		var col = []
		for x in range(10):
			col.append(-1)
		level_rows.append(col)
	level_rows[0][0] = 0

func get_player_from_tree():
	var players= get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0]
	return null

func buff(buff_name):
	var player = get_player()
	if player == null: return

	if buff_name == "shield":
		player.increase_hp(1)
	if buff_name == "speed":
		player.alter_speed(1)
	if buff_name == "weapon_size":
		player.alter_weapon_size(1)

func debuff(debuff_name):
	var player = get_player()
	if player == null: return

	if debuff_name == "speed":
		player.alter_speed(-1)
	if debuff_name == "attack_speed":
		player.alter_attack_speed(-1)

func save_player(packed_player):
	self.packed_player = null
	self.packed_player = packed_player

func save_direction(direction):
	path_taken.append(direction)

func get_player():
	var player = packed_player
	packed_player = null
	if player == null:
		player = PLAYER.instance()
	player.global_position = get_player_spawn_location()
	return player
	
func get_player_spawn_location():
	if path_taken.size() == 0:
		return default_player_location
	var most_recent_path = path_taken[-1]
	var opposite_location = ""
	if "North" in most_recent_path:
		opposite_location = "south"
	elif "South" in most_recent_path:
		opposite_location = "north"
	elif "East" in most_recent_path:
		opposite_location = "west"
	elif "West" in most_recent_path:
		opposite_location = "east"
	return get_location_coordinates(opposite_location)

func get_location_coordinates(direction):
	var target = get_tree().get_nodes_in_group(direction)
	if target.size() > 0:
		return target[0].get_center()
	return default_location

func get_enemy_spawn_location():
	if path_taken.size() == 0:
		return default_enemy_location
	var locations = ["north", "south", "east", "west"]
	var most_recent_path = path_taken[-1]
	var result = Vector2(100, 100)
	var invald_location = null
	if "North" in most_recent_path:
		invald_location = "south"
	elif "South" in most_recent_path:
		invald_location = "north"
	elif "East" in most_recent_path:
		invald_location = "west"
	elif "West" in most_recent_path:
		invald_location = "east"
	locations.erase(invald_location)
	for invalid in invalid_grid_locations():
		if invalid in locations:
			locations.erase(invalid)
	var target_location = locations[rng.randi_range(0, locations.size() - 1)]
	return get_location_coordinates(target_location)
func connect_win(level):
	for win in get_tree().get_nodes_in_group("win"):
		win.connect("win", level, "_on_win")

func random_level():
	var level = null
	if rng.randi_range(0, 100) < 15:
		level =  possible_buff_levels[rng.randi_range(0, possible_buff_levels.size() - 1)]
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
	is_new_scene = true
	var level = random_level()
	level_index += 1
	level_rows[current_level.x][current_level.y] = level_index
	return get_tree().change_scene(level)


func get_enemies():
	var enemies = []
	for index in range(number_of_enemies):
		var enemy = ENEMY.instance()
		enemy.global_position = get_enemy_spawn_location()
		enemies.append(enemy)
	return enemies

func invalid_grid_locations():
	var invald_directions = []
	if current_level.x == 0 or level_rows[current_level.x - 1][current_level.y] != -1:
		invald_directions.append("west")
	if current_level.y == 0 or level_rows[current_level.x][current_level.y - 1] != -1:
		invald_directions.append("north")
	if current_level.x == (grid_size - 1) or level_rows[grid_size - 1][current_level.y] != -1:
		invald_directions.append("west")
	if current_level.y == (grid_size - 1) or level_rows[current_level.x][grid_size - 1] != -1:
		invald_directions.append("south")
		
	return invald_directions

func disengage_spikes():
	var invalid_directions = invalid_grid_locations()
	for spike in get_tree().get_nodes_in_group("spike"):
		spike.disengage(invalid_directions)

func engage_spikes():
	for spike in get_tree().get_nodes_in_group("spike"):
		spike.engage()

func level_done():
	emit_signal("level_done")
	disengage_spikes()
	for goal in get_tree().get_nodes_in_group("win"):
		goal.winnable()

func _on_win(win_name):
	emit_signal("win")
	var player = get_tree().get_nodes_in_group("player")[0]
	player.get_parent().remove_child(player)
	save_player(player)
	save_direction(win_name)
	slain_enemies.clear()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.get_parent().remove_child(enemy)
		slain_enemies.append(enemy)

	increase_number_of_enemies()
	get_next_level(win_name)

func increase_number_of_enemies():
	number_of_enemies += 1

func level_start():
	light_fire()
	emit_signal("level_start")

func light_fire():
	#yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("light_fire")

func get_slain_enemies():
	return slain_enemies
