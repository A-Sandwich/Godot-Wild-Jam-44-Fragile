extends "res://Characters/BaseCharacter.gd"

var player = null
var speed = 100

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	
	if global_position.distance_to(player.global_position) <= 32:
		attack(direction)
	
	move_and_slide(direction * speed)


