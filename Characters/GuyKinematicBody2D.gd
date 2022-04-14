extends KinematicBody2D

signal arrived

var speed = 100
var target_location = Vector2.INF

func _ready():
	pass

func _physics_process(delta):
	if target_location == Vector2.INF:
		$AnimatedSprite.stop()
		return
	
	var direction = global_position.direction_to(target_location)
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite.flip_h = false
	move_and_slide(direction * speed)
	
	if global_position.distance_to(target_location) < 5:
		target_location = Vector2.INF
		emit_signal("arrived")
