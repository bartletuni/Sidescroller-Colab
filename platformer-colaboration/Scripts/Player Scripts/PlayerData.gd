extends Node

const SPEED = 150.0
const RUN_SPEED = 200.0
const SLIDE_SPEED = 300.0
const JUMP_VELOCITY = -425.0

var health = 10
var player_x_position = 0.0
var player_y_position = 0.0

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Slide", "Attack", "Climb"]
var current_animation = ""

var flip = false
var direction = Input
var sprint = Input
var slide = Input
var crouch = Input
var jump = Input
var climb = Input
var jumped = false
var sliding = false
var can_climb = false

#func gravity(player, delta):
	#var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
	#if gravity_on and not player.is_on_floor():
		#player.velocity += player.get_gravity() * delta

func movement_input():
	direction = Input.get_axis("move_left", "move_right")
	sprint = Input.is_action_pressed("run")
	slide = Input.is_action_pressed("crouch")
	crouch = Input.is_action_pressed("crouch")
	jump = Input.is_action_just_pressed("jump")
	climb = Input.is_action_pressed("climb")

func tracking(player):
	player_x_position = player.global_position.x
	player_y_position = player.global_position.y

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

	if direction and not sprint and not jump and not slide and not climb:
		player.velocity.x = direction * SPEED

	elif direction and sprint and not jump and not slide and not climb:
		player.velocity.x = direction * RUN_SPEED

	elif not direction:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)

	player.move_and_slide()
	
	if player.is_on_floor():
		jumped = false

func healthbar(bar):
	bar.value = health

func death(player):
	WorldData.reload()

func animator(player):
	var AnimNum = 0
	
	if jumped and not player.is_on_floor() and player.velocity.x > 0:
		player.animator.flip_h = false
		AnimNum = 3

	elif jumped and not player.is_on_floor() and player.velocity.x < 0:
		player.animator.flip_h = true
		AnimNum = 3

	elif player.velocity.x > 0 and not sprint:
		player.animator.flip_h = false
		AnimNum = 1

	elif player.velocity.x < 0 and not sprint:
		player.animator.flip_h = true
		AnimNum = 1

	elif player.velocity.x == 0:
		AnimNum = 0

	elif player.velocity.x > 0 and sprint and not slide:
		player.animator.flip_h = false
		AnimNum = 2

	elif player.velocity.x < 0 and sprint and not slide:
		player.animator.flip_h = true
		AnimNum = 2

	elif player.velocity.x > 0 and sprint and slide:
		player.animator.flip_h = false
		AnimNum = 4

	elif player.velocity.x < 0 and sprint and slide:
		player.animator.flip_h = true
		AnimNum = 4

	if can_climb and climb:
		WorldData.gravity_on = false
		player.velocity.y = -100
		AnimNum = 6

	elif can_climb and not climb and not sprint:
		WorldData.gravity_on = true
		AnimNum = 0

	elif can_climb and sprint:
		WorldData.gravity_on = false
		player.velocity.y = 0

	current_animation = animation_picker[AnimNum]
