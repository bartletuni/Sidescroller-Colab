extends Node

var left_vec = Vector2(-200, -200)
var right_vec = Vector2(200, -200)

func applied_force(object, fly_left, fly_right):
	if fly_left:
		object.apply_central_impulse(left_vec)
		fly_left = false
	elif fly_right:
		object.apply_central_impulse(right_vec)
		fly_right = false

func detect_player_attack(group, object, fly_left, fly_right):
	if "PlayerAttack" in group and (object.position.x < PlayerData.player_x_position):
		fly_left = true
	elif "PlayerAttack" in group and (object.position.x > PlayerData.player_x_position):
		fly_right = true

func detect_enemy_attack(group, object, fly_left, fly_right):
	while EnemyData.within and EnemyData.kicking > 0.65:
		if "EnemyAttack" in group and (object.position.x < EnemyData.enemy_x_position):
			fly_left = true
		elif "EnemyAttack" in group and (object.position.x > EnemyData.enemy_x_position):
			fly_right = true
			
		await get_tree().create_timer(0.3).timeout
