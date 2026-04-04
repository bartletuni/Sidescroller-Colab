extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")
		await get_tree().create_timer(0.4).timeout
		$AnimatedSprite2D.play("Idle")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.flip_h = true
		elif not is_on_floor():
			$AnimatedSprite2D.play("Jump")
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("Idle")
		

	move_and_slide()
