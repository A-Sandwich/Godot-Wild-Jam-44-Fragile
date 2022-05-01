extends Node2D

var is_flipped = false
var available_spawn_points = []

func _ready():
	pass

func connect_flip_signal(target_node):
	target_node.connect("flip_h", self, "flip_h")

func flip_h(flipped):
	if self.is_flipped == flipped:
		return

	self.is_flipped = flipped

	for child in get_children():
		if "spawn_point" in child.get_groups():
			if flipped:
				child.position.x = abs(child.position.x) * -1
			else:
				child.position.x = abs(child.position.x)

func get_point():
	var spawn_point = available_spawn_points.pop_front()
	if spawn_point != null:
		spawn_point.is_blocked = true
	return spawn_point

func _spawn_point_available(spawn_point):
	available_spawn_points.append(spawn_point)
