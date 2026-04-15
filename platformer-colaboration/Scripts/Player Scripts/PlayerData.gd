extends Node


const SPEED = 150.0
const RUN_SPEED = 200.0
const SLIDE_SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 10

var animation_picker = ["Idle", "Walk", "Run", "Jump", "Slide", "Attack"]
var current_animation = ""

var flip = false
var direction = Input
var sprint = Input
var slide = Input
var crouch = Input
var jump = Input
var jumped = false

func gravity(player, delta):
	var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

func _ready() -> void:
	pass

func movement_input():
	direction = Input.get_axis("move_left", "move_right")
	sprint = Input.is_action_pressed("run")
	slide = Input.is_action_pressed("crouch")
	crouch = Input.is_action_pressed("crouch")
	jump = Input.is_action_just_pressed("jump")
	

func player_movement(player, delta, direction, sprint, slide, crouch, jump):
	if jump and player.is_on_floor():
		player.velocity.y += JUMP_VELOCITY
		jumped = true
	
	if direction and not sprint and not jump and not slide:
		player.velocity.x = direction * SPEED

	elif direction and sprint and not jump and not slide:
		player.velocity.x = direction * RUN_SPEED

	elif direction and sprint and slide and not jump:
		player.velocity.x = direction * SLIDE_SPEED
		
	elif not direction:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)

	player.move_and_slide()
	
	if player.is_on_floor():
		jumped = false

func animator(player):
	var AnimNum = 0
	if jumped and not player.is_on_floor():
		AnimNum = 3
	elif player.velocity.x > 0 and not sprint:
		player.animation.flip_h = false
		AnimNum = 1
	elif player.velocity.x < 0 and not sprint:
		player.animation.flip_h = true
		AnimNum = 1
	elif player.velocity.x == 0:
		AnimNum = 0
	elif player.velocity.x > 0 and sprint:
		player.animation.flip_h = false
		AnimNum = 2
	elif player.velocity.x < 0 and sprint:
		player.animation.flip_h = true
		AnimNum = 2
	elif player.velocity.x > 0 and sprint and slide:
		player.animation.flip_h = false
		AnimNum = 4
	elif player.velocity.x < 0 and sprint and slide:
		player.animation.flip_h = true
		AnimNum = 4

		
	current_animation = animation_picker[AnimNum]
