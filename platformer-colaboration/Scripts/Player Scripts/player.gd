extends CharacterBody2D


const SPEED = 300.0
const RUN_SPEED = 400.0
const JUMP_VELOCITY = -400.0

@export var push_force: float = 80.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Animation.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	#var sprint = Input.action_press("run")
	if direction:
		velocity.x = direction * SPEED
		$Animation.play("Walk")
	#elif direction and sprint:
		#velocity.x = direction * RUN_SPEED
		#$Animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			collider.apply_central_force(-collision.get_normal() * push_force)
