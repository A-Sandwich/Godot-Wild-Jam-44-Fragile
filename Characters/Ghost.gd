extends Node2D

var player = null

func _ready():
	$AnimatedSprite.play("Default2")

func die():
	$AnimatedSprite.play("Die")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Die":
		queue_free()

func talk():
	var new_dialog = Dialogic.start('/Buffs/Buff-Intro')
	new_dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(new_dialog)

func _on_timeline_end(timeline_name):
	print(timeline_name)
	player.player_controlled = true
	die()

func _on_TalkArea_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.player_controlled = false
		talk()