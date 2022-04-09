extends AnimatedSprite


func _ready():
	pass

func animate(direction):
	if direction.x > 0:
		flip_h = false
		play("Run")
	if direction.x < 0:
		flip_h = true
		play("Run")
	if direction == Vector2.ZERO:
		play("Idle")
