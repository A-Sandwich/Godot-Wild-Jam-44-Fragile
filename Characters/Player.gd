extends KinematicBody2D

var SPEED = 200
var SHATTERSPRITE = preload("res://Libs/ShatterSprite.tscn")

func _ready():
	pass

func _physics_process(delta):
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
	
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite.stop()
		$AnimatedSprite.visible = false
		var shatterSprite = SHATTERSPRITE.instance()
		shatterSprite.position = position
		var image = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame).get_data()
		var imgTexture = ImageTexture.new()
		imgTexture.create_from_image(image, 0)
		shatterSprite.texture = imgTexture
		add_child(shatterSprite)
		shatterSprite.shatter()
		#$AnimatedSprite.stop()
		#var texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
		#$AnimatedSprite.visible = false
		#$Sprite.texture = texture
		#$Sprite.update()
		#$Sprite/ShardEmitter.shatter()
	
	move_and_slide(direction * SPEED)
