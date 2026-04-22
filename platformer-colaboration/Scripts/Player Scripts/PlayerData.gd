extends Node

const SPEED = 150.0
const RUN_SPEED = 200.0
const SLIDE_SPEED = 300.0
const JUMP_VELOCITY = -425.0
const MOVEMENT_LERP = 12.0
const STOP_LERP = 10.0

var health = 10
var player_x_position = 0.0
var player_y_position = 0.0
var areas_within = []
var AnimNum = 0

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Slide", "Attack", "Climb", "Attack"]
var current_animation = ""

var flip = false
var direction = Input
var sprint = Input
var slide = Input
var crouch = Input
var jump = Input
var climb = Input
var attack_left = Input
var attack_right = Input
var jumped = false
var sliding = false
var can_climb = false
var attacking = false

#PHYS_PRO: detects user input and assigns them to a respective variable
func movement_input():
	direction = Input.get_axis("move_left", "move_right")
	sprint = Input.is_action_pressed("run")
	slide = Input.is_action_pressed("crouch")
	crouch = Input.is_action_pressed("crouch")
	jump = Input.is_action_just_pressed("jump")
	climb = Input.is_action_pressed("climb")
	attack_left = Input.is_action_just_pressed("attack_left")
	attack_right = Input.is_action_just_pressed("attack_right")

#PHYS_PRO: detects areas that the player is within for refrence in objects that apply an effect or change a status
func areas_in(area):
	var overlaps = area.get_overlapping_areas()
	if not overlaps.is_empty():
		for areas in overlaps:
			areas_within = str(areas)
	else:
		areas_within = []

#PHYS_PRO: tracks player coordinate data
func tracking(player):
	player_x_position = player.global_position.x
	player_y_position = player.global_position.y

#PHYS_PRO: recieves input and applys it to player movement for sidescrolling
func player_movement(player, delta, direction, sprint, slide, crouch, jump, climb):
	if jump and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		jumped = true
		
	if slide and player.is_on_floor() and sprint:
		if player.velocity.x > 0:
			player.velocity.x = SLIDE_SPEED
			sliding = true
		if player.velocity.x < 0:
			player.velocity.x = -SLIDE_SPEED
			sliding = true

	if direction and not sprint and not jump and not slide and not climb and not attacking:
		player.velocity.x = lerp(player.velocity.x, direction * SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))

	elif direction and sprint and not jump and not slide and not climb and not attacking:
		player.velocity.x = lerp(player.velocity.x, direction * RUN_SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))
	
	elif (attacking and direction) and not sprint and not jump and not slide and not climb:
		player.velocity.x = lerp(player.velocity.x, direction * (SPEED * 0.5), clampf(MOVEMENT_LERP * delta, 0, 1))

	elif not direction:
		player.velocity.x = lerp(player.velocity.x, 0.0, clampf(STOP_LERP * delta, 0, 1))
		if abs(player.velocity.x) < 1:
			player.velocity.x = 0

	player.move_and_slide()
	
	if player.is_on_floor():
		jumped = false

#PHYS_PRO: applies player health to the healthbar
func healthbar(bar):
	bar.value = health

#PHYS_PRO: enables player attack when the correct input is used
func attack(leftbox, rightbox):
	if attack_right:
		attacking = true
		rightbox.set_deferred("disabled", false)
		await get_tree().create_timer(0.35).timeout
		rightbox.set_deferred("disabled", true)
		attacking = false
	elif attack_left:
		attacking = true
		rightbox.set_deferred("disabled", false)
		await get_tree().create_timer(0.35).timeout
		rightbox.set_deferred("disabled", true)
		attacking = false

#PHYS_PRO: detecrts player state based on movement and applies an applicable animation
func animator(player):
	if jumped and not player.is_on_floor() and player.velocity.x > 0:
		player.animator.flip_h = false
		AnimNum = 3

	elif jumped and not player.is_on_floor() and player.velocity.x < 0:
		player.animator.flip_h = true
		AnimNum = 3

	elif player.velocity.x > 25 and not sprint and not attacking:
		player.animator.flip_h = false
		AnimNum = 1

	elif player.velocity.x < -25 and not sprint and not attacking:
		player.animator.flip_h = true
		AnimNum = 1

	elif player.velocity.x > -25 and player.velocity.x < 25 and not attacking:
		AnimNum = 0

	elif player.velocity.x > 0 and sprint and not slide and not attacking:
		player.animator.flip_h = false
		AnimNum = 2

	elif player.velocity.x < 0 and sprint and not slide and not attacking:
		player.animator.flip_h = true
		AnimNum = 2

	elif player.velocity.x > 0 and sprint and slide and not attacking:
		player.animator.flip_h = false
		AnimNum = 4

	elif player.velocity.x < 0 and sprint and slide and not attacking:
		player.animator.flip_h = true
		AnimNum = 4

	if can_climb and climb and not attacking:
		WorldData.gravity_on = false
		player.velocity.y = -100
		AnimNum = 6

	elif can_climb and not climb and not sprint and not attacking:
		WorldData.gravity_on = true
		AnimNum = 0

	elif can_climb and sprint and not attacking:
		WorldData.gravity_on = false
		player.velocity.y = 0

	if attacking and attack_left:
		player.animator.flip_h = true
		AnimNum = 7
	elif attacking and attack_right:
		player.animator.flip_h = false
		AnimNum = 7

	current_animation = animation_picker[AnimNum]
