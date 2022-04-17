extends Node2D

signal win
export var direction = ""

func _ready():
	visible = false
	$Area2D.set_deferred("monitoring", false)
	if direction != "":
		add_to_group(direction.to_lower())
	self.connect("win", State, "_on_win")

func winnable():
	visible = true
	$Area2D.set_deferred("monitoring", true)

func _on_Area2D_body_entered(body):
	if not visible:
		return
	emit_signal("win", direction)

func get_center():
	return $Particles2D.global_position
