extends Node

const HEALTH = 5
const SPEED = 125
const JUMP_HEIGHT = -325.0
const DAMAGE = 1
const MOVEMENT_LERP = 8.0
const STOP_LERP = 15.0
const ATTACK_DELAY = 0.5
const ATTACK_LENGTH = 0.2

var health = HEALTH
var speed = SPEED
var attacking = 0
var chasing = false
var move_direction = 1
var enemy_x_position	 = 0.0
var enemy_y_position = 0.0
var within = false
var kicking = 0.0
var jump_height = JUMP_HEIGHT
var dying = false
var player_within_hitbox = false
var attack_loop_running = false
var hitbox_resetting = false

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Attack"]
var current_animation = ""

func orientation(animator):
	if chasing:
		if PlayerData.player_x_position > enemy_x_position:
			animator.flip_h = false
		elif PlayerData.player_x_position < enemy_x_position:
			animator.flip_h = true
	else:
		pass

#PHYS_PRO: tracks enemy position
func tracking(enemy):
	enemy_x_position = enemy.global_position.x
	enemy_y_position = enemy.global_position.y

func standard_enemy_movement(enemy, player, detection_radius):
	pass

#PHYS_PRO: Checks if the raycasts are colliding with anything then checks if that thing is a part of the level. If it is it switches the direction that the enemy is moving
func ray_movement(enemy, delta, ray_left, ray_right):
	if ray_left.is_colliding() and not chasing:
		var RayLeftCollider = ray_left.get_collider().get_class()
		if RayLeftCollider == "TileMapLayer":
			move_direction = 1
	elif ray_right.is_colliding() and not chasing:
		var RayRightCollider = ray_right.get_collider().get_class()
		if RayRightCollider == "TileMapLayer":
			move_direction = -1

	if not attacking == 1:
		enemy.velocity.x = lerp(enemy.velocity.x, float(speed * move_direction), clampf(MOVEMENT_LERP * delta, 0, 1))
	else:
		enemy.velocity.x = lerp(enemy.velocity.x, 0.0, clampf(STOP_LERP * delta, 0, 1))
		if abs(enemy.velocity.x) < 1:
			enemy.velocity.x = 0

	enemy.move_and_slide()

func pathfinding_movement(enemy, player):
	pass

func take_damage(area):
	var group = area.get_overlapping_areas()
	if "AttackBox" in group:
		health -= 1

func damage(enemy_damage):
	PlayerData.health -= enemy_damage
	
func health_bar(health_bar):
	health_bar.value = health

func player_in_hitbox(hitbox):
	player_within_hitbox = false
	for body in hitbox.get_overlapping_bodies():
		var groups = body.get_groups()
		if "Players" in groups:
			player_within_hitbox = true
			break

func attack_player(hitbox, hitbox_shape, enemy_damage):
	attack_loop_running = true
	while player_within_hitbox and not dying:
		attacking = 1
		damage(enemy_damage)
		
		if is_instance_valid(hitbox_shape):
			hitbox_resetting = true
			hitbox_shape.set_deferred("disabled", true)
			await get_tree().physics_frame
			if is_instance_valid(hitbox_shape):
				hitbox_shape.set_deferred("disabled", false)
			await get_tree().physics_frame
			hitbox_resetting = false
		
		await get_tree().create_timer(ATTACK_LENGTH).timeout
		attacking = 0
		await get_tree().create_timer(ATTACK_DELAY).timeout
		
		if is_instance_valid(hitbox):
			player_in_hitbox(hitbox)
		else:
			player_within_hitbox = false
	
	attacking = 0
	attack_loop_running = false
	hitbox_resetting = false

func death(enemy, animator):
	if health <= 0 and not dying and is_instance_valid(enemy):
		dying = true
		attacking = 0
		chasing = false
		player_within_hitbox = false
		attack_loop_running = false
		hitbox_resetting = false
		animator.play("Death")
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(enemy):
			enemy.queue_free()
		health = HEALTH
		dying = false

func facing(animator):
	if chasing:
		if PlayerData.player_x_position > enemy_x_position:
			move_direction = 1
		elif PlayerData.player_x_position < enemy_x_position:
			move_direction = -1
		if PlayerData.player_x_position > enemy_x_position:
			animator.flip_h = false
		elif PlayerData.player_x_position < enemy_x_position:
			animator.flip_h = true

func run(animator):
	speed = SPEED * 1.2

func walk():
	speed = SPEED
	
func jump(enemy):
	enemy.velocity.y = jump_height

func animation(enemy):
	var AnimNum = 0
	
	if enemy.velocity.x > 0 and enemy.velocity.x < 126 and not attacking == 1 and not enemy.velocity.y != 0:
		enemy.animator.flip_h = false
		AnimNum = 1
		
	elif enemy.velocity.x < 0 and enemy.velocity.x < 126 and not attacking == 1 and not enemy.velocity.y != 0:
		enemy.animator.flip_h = true
		AnimNum = 1
		
	elif enemy.velocity.x == 0 and not attacking == 1 and not enemy.velocity.y != 0:
		AnimNum = 0
		
	elif enemy.velocity.y != 0:
		AnimNum = 3
		
	if enemy.velocity.x > 125 and not attacking == 1 and not enemy.velocity.y != 0:
		enemy.animator.flip_h = false
		AnimNum = 2
		
	elif enemy.velocity.x < -125 and not attacking == 1 and not enemy.velocity.y != 0:
		enemy.animator.flip_h = true
		AnimNum = 2
		
	elif attacking == 1:
		AnimNum = 4

	current_animation = animation_picker[AnimNum]
