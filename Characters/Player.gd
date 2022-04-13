extends "res://Characters/BaseCharacter.gd"

var SPEED = 200
func _ready():
	pass

func _physics_process(delta):
	if not is_alive:
		return
	ProcessInput()

func ProcessInput():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	
	var attack_direction = Vector2.ZERO
	if Input.is_action_pressed("attack_up"):
		attack_direction.y = -1
	if Input.is_action_pressed("attack_down"):
		attack_direction.y = 1
	if Input.is_action_pressed("attack_right"):
		attack_direction.x = 1
	if Input.is_action_pressed("attack_left"):
		attack_direction.x = -1
	if attack_direction != Vector2.ZERO:
		emit_signal("attack", attack_direction)

		#$AnimatedSprite.stop()
		#$AnimatedSprite.visible = false
		#var shatterSprite = SHATTERSPRITE.instance()
		#shatterSprite.position = position
		#var image = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame).get_data()
		#var imgTexture = ImageTexture.new()
		#imgTexture.create_from_image(image, 0)
		#shatterSprite.texture = imgTexture
		#add_child(shatterSprite)
		#shatterSprite.shatter()
	$AnimatedSprite.animate(direction)
	var result = _knocback()
	if result != Vector2.ZERO:
		if $Pushback.time_left == 0:
			$Pushback.start()
		move_and_slide(result)
	else:
		move_and_slide(direction * SPEED)


func _on_Pushback_timeout():
	knockback = Vector2.ZERO
