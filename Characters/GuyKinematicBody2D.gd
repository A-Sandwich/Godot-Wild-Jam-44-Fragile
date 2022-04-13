extends KinematicBody2D

var speed = 100
var target_location = Vector2.INF

func _ready():
	pass

func _physics_process(delta):
	if target_location == Vector2.INF:
		return
	
	var direction = global_position.direction_to(target_location)
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite.flip_h = false
	move_and_slide(direction * speed)
