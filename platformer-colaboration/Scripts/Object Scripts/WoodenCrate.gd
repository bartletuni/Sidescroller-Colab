extends StaticBody2D

const HEALTH = 4

var health = HEALTH

func _physics_process(delta: float) -> void:
	if health == 4:
		$Animator.play("Full")
	elif health == 2:
		$Animator.play("Broken")
	elif health < 1:
		$Animator.play("Destroyed")

func _on_hitbox_area_entered(area: Area2D) -> void:
	var group = area.get_groups()
	if "PlayerAttack" in group:
		health -= 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	_on_hitbox_area_entered(area)
