extends RigidBody2D

@onready var wooden_crate: RigidBody2D = $"."

var fly_left = false
var fly_right = false
var left_vec = Vector2(-200, -200)
var right_vec = Vector2(200, -200)



func _physics_process(delta: float) -> void:
	if fly_left:
		wooden_crate.apply_central_impulse(left_vec)
		fly_left = false
	elif fly_right:
		wooden_crate.apply_central_impulse(right_vec)
		fly_right = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if "PlayerAttack" in groups and (wooden_crate.position.x < PlayerData.player_x_position):
		fly_left = true
	elif "PlayerAttack" in groups and (wooden_crate.position.x > PlayerData.player_x_position):
		fly_right = true


func _on_enemyattackbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	while EnemyData.within and EnemyData.kicking > 0.65:
		if "EnemyAttack" in groups and (wooden_crate.position.x < EnemyData.enemy_x_position):
			fly_left = true
		elif "EnemyAttack" in groups and (wooden_crate.position.x > EnemyData.enemy_x_position):
			fly_right = true
			
		await get_tree().create_timer(0.3).timeout
