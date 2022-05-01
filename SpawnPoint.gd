extends Node2D

signal available

var is_blocked = false

func _ready():
	connect("available", get_parent(), "_spawn_point_available", [self])
	emit_signal("available")

func _setup(spawned_node):
	is_blocked = true
	spawned_node.connect("launch", self, "_launch")

func _launch():
	is_blocked = false
	emit_signal("available", self)
