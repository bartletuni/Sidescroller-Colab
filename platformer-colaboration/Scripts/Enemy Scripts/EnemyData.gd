extends Node

const HEALTH = 5
const SPEED = 125
const DAMAGE = 1

var speed = SPEED
var attacking = 0

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Attack"]
var current_animation = ""

func standard_enemy_movement(enemy, player, detection_radius):
	pass
	
func ray_movement(enemy, ray_left, ray_right):
	#Checks if the raycasts are colliding with anything then checks if that thing is a part of the level. If it is it switches the direction that the enemy is moving
	if ray_left.is_colliding():
		var RayLeftCollider = ray_left.get_collider().get_class()
		if RayLeftCollider == "TileMapLayer":
			enemy.velocity.x = speed
	if ray_right.is_colliding():
		var RayRightCollider = ray_right.get_collider().get_class()
		if RayRightCollider == "TileMapLayer":
			enemy.velocity.x = -speed
			
	enemy.move_and_slide()

func pathfinding_movement(enemy, player):
	pass

func damage(enemy_damage):
	PlayerData.health -= enemy_damage

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
		
	elif enemy.velocity.x > 125 and not attacking == 1:
		enemy.animator.flip_h = false
		AnimNum = 2
		
	elif enemy.velocity.x < -125 and not attacking == 1:
		enemy.animator.flip_h = true
		AnimNum = 2
		
	elif attacking == 1:
		enemy.velocity.x = enemy.velocity.x * 0
		AnimNum = 4

	current_animation = animation_picker[AnimNum]
