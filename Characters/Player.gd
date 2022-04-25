extends "res://Characters/BaseCharacter.gd"

var player_controlled = true
var rng = RandomNumberGenerator.new()
var dash_speed_multiplier = 2.5
var is_dashing = false

func _ready():
	rng.randomize()
	speed = 200
	$AnimatedSprite.play("Idle")
	._ready()

func _physics_process(delta):
	if not is_alive or not player_controlled:
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

	var movement_speed = speed
	if not is_dashing and Input.is_action_just_pressed("attack"):
		emit_signal("attack", direction)
		_dash()

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
	#if attack_direction != Vector2.ZERO:
	if not is_dashing and Input.is_action_just_pressed("dash"):
		$DashSound.play()
		print(speed)
		_dash()
		#direction = attack_direction
	$AnimatedSprite.animate(direction)
	var result = _knocback()
	if result != Vector2.ZERO:
		if $Pushback.time_left == 0:
			$Pushback.start()
		move_and_slide(result)
	else:
		most_recent_direction = direction
		if is_dashing:
			movement_speed *= dash_speed_multiplier
		move_and_slide(direction * movement_speed)

func _dash():
	$Dash.start()
	is_dashing = true

func _on_Pushback_timeout():
	knockback = Vector2.ZERO

func _damage(body):
	._damage(body)

func alter_dash_speed(buff_or_debuff):
	print("Altering dash speed")
	var amount = rng.randi_range(.1, .25) * buff_or_debuff
	$Sword.attack_speed = $Sword.attack_speed + amount

func alter_attack_speed(buff_or_debuff = 1):
	print("Altering attack speed")
	var amount = rng.randi_range(.1, .25) * buff_or_debuff
	$Sword.attack_speed = $Sword.attack_speed + amount

func alter_weapon_size(buff_or_debuff = 1):
	print("Altering weapon size")
	var amount = rng.randf_range(0.2, 0.5) * buff_or_debuff
	$Sword.scale = $Sword.scale + Vector2(amount, amount)
	
func increase_hp(amount):
	print("Increasing hp")
	hp += amount
	
func alter_speed(buff_or_debuff = 1):
	print("Altering speed")
	var amount = rng.randi_range(40, 90) * buff_or_debuff
	self.speed = self.speed + amount

func _on_Player_tree_entered():
	detect_darkness()


func _on_Dash_timeout():
	is_dashing = false
