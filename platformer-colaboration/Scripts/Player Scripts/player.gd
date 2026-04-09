extends CharacterBody2D


const SPEED = 150.0
const RUN_SPEED = 250.0
const JUMP_VELOCITY = -400.0

@export var push_force: float = 80.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var jump := Input.is_action_just_pressed("jump")
	
	if jump and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		$Animation.play("Jump")
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		


	var direction := Input.get_axis("move_left", "move_right")
	var sprint := Input.is_action_pressed("run")
	if direction and not sprint and not jump:
		velocity.x = direction * SPEED
		if velocity.x > 0 and is_on_floor():
			$Animation.flip_h = false
			$Animation.play("Walk")
		elif velocity.x < 0 and is_on_floor():
			$Animation.flip_h = true
			$Animation.play("Walk")
	elif direction and sprint and not jump:
		velocity.x = direction * RUN_SPEED
		if velocity.x > 0 and is_on_floor():
			$Animation.flip_h = false
			$Animation.play("Run")
		elif velocity.x < 0 and is_on_floor():
			$Animation.flip_h = true
			$Animation.play("Run")
	elif not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Animation.play("Idle")
	
	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
		#
		#if collider is RigidBody2D:
			#collider.apply_central_force(-collision.get_normal() * push_force)
