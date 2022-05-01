extends KinematicBody2D

signal damage
signal launch

var direction = Vector2.ZERO
var speed = 125
var hit = false
var radians = 0.0
var can_move = false

func _ready():
	for damageable in get_tree().get_nodes_in_group("damageable"):
		connect("damage", damageable, "_damage")
	$AnimatedSprite.play("Shoot")
	if direction.x > 0:
		# the sprite is rotated 90 degrees so flip_v actually flips horizontally
		$AnimatedSprite.flip_v = true
	if radians != 0.0:
		$Trail.rotate(radians)


func _physics_process(delta):
	if hit or !can_move:
		return

	var collision = move_and_collide(direction * speed * delta)
	
	if collision != null:
		hit = true
		if "damageable" in collision.collider.get_groups():
			emit_signal("damage", collision.collider)
		print(collision.collider.name, "fireball!")
		$AnimatedSprite.play("GoOut")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "GoOut":
		queue_free()
	elif $AnimatedSprite.animation == "Shoot":
		can_move = true
		$Trail.emitting = true
		$AnimatedSprite.play("Flying")
		yield(get_tree().create_timer(0.5), "timeout")
		emit_signal("launch")
