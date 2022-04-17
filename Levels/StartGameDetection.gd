extends Node2D


func _on_East_body_entered(body):
	engage_spikes(body)


func _on_West_body_entered(body):
	engage_spikes(body)


func _on_North_body_entered(body):
	engage_spikes(body)


func _on_South_body_entered(body):
	engage_spikes(body)

func engage_spikes(body):
	if body.is_in_group("player"):
		State.engage_spikes()
	stop_monitoring()

func stop_monitoring():
	for child in get_children():
		if child is Area2D:
			child.set_deferred("monitoring", false)
