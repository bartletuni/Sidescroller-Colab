extends Node

const HEALTH = 5
const SPEED = 125
const DAMAGE = 1

var speed = SPEED
var attacking = 0
var chasing = false
var move_direction = 1
var enemy_x_position	 = 0.0
var enemy_y_position = 0.0

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Attack"]
var current_animation = ""

#PHYS_PRO: tracks enemy position
func tracking(enemy):
	enemy_x_position = enemy.global_position.x
	enemy_y_position = enemy.global_position.y

func standard_enemy_movement(enemy, player, detection_radius):
	pass

#PHYS_PRO: Checks if the raycasts are colliding with anything then checks if that thing is a part of the level. If it is it switches the direction that the enemy is moving
func ray_movement(enemy, ray_left, ray_right):
	if ray_left.is_colliding() and not chasing:
		var RayLeftCollider = ray_left.get_collider().get_class()
		if RayLeftCollider == "TileMapLayer":
			move_direction = 1
	elif ray_right.is_colliding() and not chasing:
		var RayRightCollider = ray_right.get_collider().get_class()
		if RayRightCollider == "TileMapLayer":
			move_direction = -1

	if not attacking == 1:
		enemy.velocity.x = speed * move_direction

	enemy.move_and_slide()

func pathfinding_movement(enemy, player):
	pass

func damage(enemy_damage):
	PlayerData.health -= enemy_damage

func run():
	if PlayerData.player_x_position > enemy_x_position:
		move_direction = 1
	elif PlayerData.player_x_position < enemy_x_position:
		move_direction = -1

	speed = SPEED * 1.2

func walk():
	speed = SPEED

func animation(enemy):
	var AnimNum = 0
	
	if enemy.velocity.x > 0 and enemy.velocity.x < 126 and not attacking == 1:
		enemy.animator.flip_h = false
		AnimNum = 1
		
	elif enemy.velocity.x < 0 and enemy.velocity.x < 126 and not attacking == 1:
		enemy.animator.flip_h = true
		AnimNum = 1
		
	elif enemy.velocity.x == 0 and not attacking == 1:
		AnimNum = 0
		
	if enemy.velocity.x > 125 and not attacking == 1:
		enemy.animator.flip_h = false
		AnimNum = 2
		
	elif enemy.velocity.x < -125 and not attacking == 1:
		enemy.animator.flip_h = true
		AnimNum = 2
		
	elif attacking == 1:
		enemy.velocity.x = enemy.velocity.x * 0
		AnimNum = 4

	current_animation = animation_picker[AnimNum]
