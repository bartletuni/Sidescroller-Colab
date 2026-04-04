extends CharacterBody2D

@onready var ray_cast_right: RayCast2D = $RaycastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

const SPEED = 200.0

var direction = 1

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
		
	position.x += direction * SPEED * delta

func _physics_process(delta: float) -> void:
	pass
