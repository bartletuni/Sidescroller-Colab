extends StaticBody2D

func _on_climb_box_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		PlayerData.can_climb = true


func _on_climb_box_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	WorldData.gravity_on = true
	if "Players" in groups:
		PlayerData.can_climb = false
