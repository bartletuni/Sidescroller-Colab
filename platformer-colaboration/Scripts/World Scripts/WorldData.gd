extends Node

var gravity_on = true

#On Call: reloads the current scene
func reload():
	get_tree().reload_current_scene()

#PHYS_PRO: add gravity to whatever entity it is applied to
func gravity(player, delta):
	var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
	if gravity_on and not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
