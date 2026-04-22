extends CharacterBody2D

@onready var enemy: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator

var enemy_damage = 1

func _ready() -> void:
	EnemyData.walk()
	velocity.x = EnemyData.speed

func _physics_process(delta: float) -> void:
	EnemyData.facing($Animator)
	
	EnemyData.orientation($Animator)
	
	EnemyData.tracking(enemy)
	
	EnemyData.ray_movement(enemy, delta, $RayLeft, $RayRight)
	
	EnemyData.animation(enemy)
	
	WorldData.gravity(enemy, delta)
	
	$Animator.play(EnemyData.current_animation)

func _on_detection_radius_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.chasing = true
		EnemyData.run($Animator)

func _on_detection_radius_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.chasing = false
		if $RayLeft.is_colliding():
			EnemyData.move_direction = 1
		elif $RayRight.is_colliding():
			EnemyData.move_direction = -1
		EnemyData.walk()


func _on_hitbox_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.attacking = 1
		EnemyData.damage(enemy_damage)


func _on_hitbox_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.attacking = 0
