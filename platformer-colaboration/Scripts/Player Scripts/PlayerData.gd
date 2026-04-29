extends Node2D

enum PlayerState {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FALL,
	SLIDE,
	CLIMB,
	ATTACK
}

const SPEED = 150.0
const RUN_SPEED = 200.0
const SLIDE_SPEED = 300.0
const JUMP_VELOCITY = -425.0
const MOVEMENT_LERP = 12.0
const STOP_LERP = 10.0

var health = 10
var player_x_position = 0.0
var player_y_position = 0.0
var playermouse_x_position = 0.0
var areas_within = []

var current_state: PlayerState = PlayerState.IDLE

var direction = 0.0
var sprint = false
var slide = false
var crouch = false
var jump = false
var climb = false
var attack_left = false
var attack_right = false
var click_attack = false

var can_climb = false
var attack_direction = 1

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
	click_attack = Input.is_action_just_pressed("click_attack")

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
	playermouse_x_position = get_global_mouse_position().x

#PHYS_PRO: applies player health to the healthbar
func healthbar(bar):
	bar.value = health

func update_state(player):
	match current_state:
		PlayerState.IDLE:
			if not player.is_on_floor():
				current_state = PlayerState.FALL
			elif jump:
				current_state = PlayerState.JUMP
			elif direction != 0:
				if sprint:
					current_state = PlayerState.RUN
				else:
					current_state = PlayerState.WALK
			elif can_climb and climb:
				current_state = PlayerState.CLIMB
		PlayerState.WALK:
			if not player.is_on_floor():
				current_state = PlayerState.FALL
			elif jump:
				current_state = PlayerState.JUMP
			elif direction == 0:
				current_state = PlayerState.IDLE
			elif sprint:
				current_state = PlayerState.RUN
			elif can_climb and climb:
				current_state = PlayerState.CLIMB
		PlayerState.RUN:
			if not player.is_on_floor():
				current_state = PlayerState.FALL
			elif jump:
				current_state = PlayerState.JUMP
			elif slide and player.is_on_floor():
				current_state = PlayerState.SLIDE
			elif direction == 0:
				current_state = PlayerState.IDLE
			elif not sprint:
				current_state = PlayerState.WALK
			elif can_climb and climb:
				current_state = PlayerState.CLIMB
		PlayerState.JUMP, PlayerState.FALL:
			if player.is_on_floor():
				if direction == 0:
					current_state = PlayerState.IDLE
				elif sprint:
					current_state = PlayerState.RUN
				else:
					current_state = PlayerState.WALK
			elif player.velocity.y >= 0 and current_state == PlayerState.JUMP:
				current_state = PlayerState.FALL
			elif can_climb and climb:
				current_state = PlayerState.CLIMB
		PlayerState.SLIDE:
			if not slide or not sprint or not player.is_on_floor():
				if not player.is_on_floor():
					current_state = PlayerState.FALL
				elif direction == 0:
					current_state = PlayerState.IDLE
				elif sprint:
					current_state = PlayerState.RUN
				else:
					current_state = PlayerState.WALK
		PlayerState.CLIMB:
			if not can_climb or not climb:
				if not player.is_on_floor():
					current_state = PlayerState.FALL
				else:
					current_state = PlayerState.IDLE
		PlayerState.ATTACK:
			if not player.is_on_floor() and can_climb and climb:
				current_state = PlayerState.CLIMB

#PHYS_PRO: recieves input and applys it to player movement for sidescrolling
func player_movement(player, delta):
	update_state(player)
	
	if current_state == PlayerState.CLIMB:
		WorldData.gravity_on = false
		player.velocity.y = -100
		player.velocity.x = 0
	else:
		WorldData.gravity_on = true

	match current_state:
		PlayerState.IDLE:
			player.velocity.x = lerp(player.velocity.x, 0.0, clampf(STOP_LERP * delta, 0, 1))
			if abs(player.velocity.x) < 1:
				player.velocity.x = 0
		PlayerState.WALK:
			player.velocity.x = lerp(player.velocity.x, direction * SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))
		PlayerState.RUN:
			player.velocity.x = lerp(player.velocity.x, direction * RUN_SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))
		PlayerState.JUMP:
			if player.is_on_floor():
				player.velocity.y = JUMP_VELOCITY
			player.velocity.x = lerp(player.velocity.x, direction * SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))
		PlayerState.FALL:
			player.velocity.x = lerp(player.velocity.x, direction * SPEED, clampf(MOVEMENT_LERP * delta, 0, 1))
		PlayerState.SLIDE:
			if player.velocity.x > 0:
				player.velocity.x = SLIDE_SPEED
			elif player.velocity.x < 0:
				player.velocity.x = -SLIDE_SPEED
			elif not player.animator.flip_h:
				player.velocity.x = SLIDE_SPEED
			else:
				player.velocity.x = -SLIDE_SPEED
		PlayerState.ATTACK:
			player.velocity.x = lerp(player.velocity.x, direction * (SPEED * 0.5), clampf(MOVEMENT_LERP * delta, 0, 1))

	player.move_and_slide()

#PHYS_PRO: enables player attack when the correct input is used
func attack(leftbox, rightbox):
	if health > 0 and current_state != PlayerState.ATTACK and current_state != PlayerState.SLIDE and current_state != PlayerState.CLIMB:
		var attackbox = null
		var wants_to_attack = false
		
		if attack_right:
			wants_to_attack = true
			attack_direction = 1
			attackbox = rightbox
		elif click_attack:
			wants_to_attack = true
			if player_x_position > playermouse_x_position:
				attack_direction = -1
				attackbox = leftbox
			else:
				attack_direction = 1
				attackbox = rightbox
		elif attack_left:
			wants_to_attack = true
			attack_direction = -1
			attackbox = leftbox
		
		if wants_to_attack and attackbox != null:
			current_state = PlayerState.ATTACK
			
			if is_instance_valid(leftbox):
				leftbox.set_deferred("disabled", true)
			if is_instance_valid(rightbox):
				rightbox.set_deferred("disabled", true)
			if is_instance_valid(attackbox):
				attackbox.set_deferred("disabled", false)
			
			await get_tree().create_timer(0.35).timeout
			
			if is_instance_valid(leftbox):
				leftbox.set_deferred("disabled", true)
			if is_instance_valid(rightbox):
				rightbox.set_deferred("disabled", true)
			if is_instance_valid(attackbox):
				attackbox.set_deferred("disabled", true)
			
			if current_state == PlayerState.ATTACK:
				current_state = PlayerState.IDLE

#PHYS_PRO: detecrts player state based on movement and applies an applicable animation
func animator(player):
	if current_state == PlayerState.ATTACK:
		if attack_direction < 0:
			player.animator.flip_h = true
		elif attack_direction > 0:
			player.animator.flip_h = false
	else:
		if direction < 0:
			player.animator.flip_h = true
		elif direction > 0:
			player.animator.flip_h = false

	var anim = ""
	match current_state:
		PlayerState.IDLE:
			anim = "Idle"
		PlayerState.WALK:
			anim = "Walk"
		PlayerState.RUN:
			anim = "Run"
		PlayerState.JUMP, PlayerState.FALL:
			anim = "Jump"
		PlayerState.SLIDE:
			anim = "Slide"
		PlayerState.CLIMB:
			anim = "Climb"
		PlayerState.ATTACK:
			anim = "Attack"
	
	if player.animator.animation != anim:
		player.animator.play(anim)
