extends RigidBody2D

@onready var wooden_crate: RigidBody2D = $"."

var fly_left = false
var fly_right = false

func _physics_process(delta: float) -> void:
	ObjectData.applied_force(wooden_crate, fly_left, fly_right)

func _on_hitbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	ObjectData.detect_player_attack(groups, wooden_crate, fly_left, fly_right)


func _on_enemyattackbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	ObjectData.detect_enemy_attack(groups, wooden_crate, fly_left, fly_right)
