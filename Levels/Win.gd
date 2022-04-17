extends Node2D

signal win
export var direction = ""

func _ready():
	visible = false
	$Area2D.set_deferred("monitoring", false)
	if direction != "":
		add_to_group(direction.to_lower())
	print(get_groups(), "%%%%%%%%%%%%%%%%%%%%%%%")
	self.connect("win", State, "_on_win")

func winnable():
	visible = true
	$Area2D.set_deferred("monitoring", true)

func _on_Area2D_body_entered(body):
	if not visible:
		return
	print(get_parent().name, "!!")
	emit_signal("win", direction)


func _on_Area2D_area_entered(area):
	print(area.name, "!")


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area.name, "!!!")


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body.name, "!!!!")

func get_center():
	return $Particles2D.global_position
