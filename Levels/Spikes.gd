extends Node2D

export var direction = ""
var spike_engaged = false

func _ready():
	pass

func engage():
	if spike_engaged:
		return
	spike_engaged = true
	$AnimatedSprite.play("default")
	$Area2D.set_deferred("monitorable", true)
	$Area2D.set_deferred("monitoring", true)

func disengage(locked_directions):
	var temp = ""
	if (locked_directions == null or locked_directions.size() == 0 or 
		not direction in locked_directions):
		spike_engaged = false
		$AnimatedSprite.play("default", true)
		$Area2D.set_deferred("monitorable", false)
		$Area2D.set_deferred("monitoring", false)

func _on_AnimatedSprite_animation_finished():
	#$Area2D.set_deferred("monitorable", true)
	pass


func _on_Area2D_body_entered(body):
	if body.has_method("_damage") and $AnimatedSprite.frame == 3:
		body._damage(body)
