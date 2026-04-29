extends RigidBody2D

@onready var wooden_crate: RigidBody2D = $"."

var fly_left = false
var fly_right = false
var left_vec = Vector2(-200, -200)
var right_vec = Vector2(200, -200)

var is_kicked = false
var kick_start_y = 0.0
const DAMAGE_HEIGHT_THRESHOLD = 50.0
var can_damage = false

func _physics_process(delta: float) -> void:
	if fly_left:
		wooden_crate.apply_central_impulse(left_vec)
		fly_left = false
		is_kicked = true
		can_damage = false
		kick_start_y = position.y
	elif fly_right:
		wooden_crate.apply_central_impulse(right_vec)
		fly_right = false
		is_kicked = true
		can_damage = false
		kick_start_y = position.y

	if is_kicked:
		if kick_start_y - position.y >= DAMAGE_HEIGHT_THRESHOLD:
			can_damage = true
			is_kicked = false

	if can_damage:
		for body in $hitbox.get_overlapping_bodies():
			var groups = body.get_groups()
			if "Players" in groups:
				PlayerData.health -= 1
				can_damage = false
			elif "Enemies" in groups:
				EnemyData.health -= 1
				can_damage = false
		
		if linear_velocity.length() < 10.0:
			can_damage = false


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
