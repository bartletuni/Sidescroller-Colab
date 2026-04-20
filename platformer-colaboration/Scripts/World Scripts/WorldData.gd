extends Node

var gravity_on = true

func reload():
	#await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()

func gravity(player, delta):
	var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
	if gravity_on and not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
