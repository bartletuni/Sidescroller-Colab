extends CharacterBody2D

@onready var enemy: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator

var enemy_damage = 1

func _ready() -> void:
	EnemyData.walk()
	EnemyData.attacking = 0
	EnemyData.move_direction = 1
	velocity.x = EnemyData.speed

func _physics_process(delta: float) -> void:
	EnemyData.tracking(enemy)
	
	EnemyData.ray_movement(enemy, $RayLeft, $RayRight)
	
	EnemyData.animation(enemy)
	
	$Animator.play(EnemyData.current_animation)

func _on_detection_radius_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.run()

func _on_detection_radius_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
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
