extends "res://Characters/BaseCharacter.gd"

var player_controlled = true
var rng = RandomNumberGenerator.new()
var dash_speed_multiplier = 2.5
var is_dashing = false
var dash_distance = 0.1
var dash_distance_multiplier = 3

func _ready():
	rng.randomize()
	speed = 200
	$AnimatedSprite.play("Idle")
	._ready()
	$"/root/State".connect("alter_attribute", self, "_apply_attribute_change")

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
	if not is_dashing and Input.is_action_just_pressed("attack") and $Dash.time_left == 0:
		if $Sword/Cooldown.time_left == 0:
			_dash(dash_distance, false)
		emit_signal("attack", direction)

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
	if not is_dashing and Input.is_action_just_pressed("dash") and $Dash.time_left == 0:
		$DashSound.play()
		print(speed)
		_dash(dash_distance * dash_distance_multiplier)
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

func _dash(distance, invulnerable = true):
	$Dash.wait_time = distance
	$Dash.start()
	is_invulnerable = invulnerable
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
	var amount = rng.randf_range(0.4, 0.6) * buff_or_debuff
	$Sword.scale = $Sword.scale + Vector2(amount, amount)
	$Sword.update()
	
func alter_dash_distance(buff_or_debuff = 1):
	print("Altering dash distance")
	dash_distance_multiplier += buff_or_debuff

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
	is_invulnerable = false

func _apply_attribute_change(attribute_name, buff_or_debuff):
	if attribute_name == "speed":
		alter_speed(buff_or_debuff)
	if attribute_name == "attack_speed":
		alter_attack_speed(buff_or_debuff)
	if attribute_name == "dash_distance":
		alter_dash_distance(buff_or_debuff)
	if attribute_name == "weapon_size":
		alter_weapon_size(buff_or_debuff)
	if attribute_name == "shield":
		increase_hp(buff_or_debuff)

