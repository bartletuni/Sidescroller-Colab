extends StaticBody2D

const HEALTH = 2

var health = HEALTH

func _physics_process(delta: float) -> void:
	if health == 2:
		$Animator.play("Full")
	elif health == 1:
		$Animator.play("Broken")
	elif health < 1:
		$Animator.play("Destroyed")

func _on_hitbox_area_entered(area: Area2D) -> void:
	var group = area.get_groups()
	if "PlayerAttack" in group:
		health -= 1
