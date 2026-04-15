extends Node

func reload():
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
