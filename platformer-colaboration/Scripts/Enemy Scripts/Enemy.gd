extends CharacterBody2D

@onready var enemy: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator

var enemy_damage = 1

func _ready() -> void:
	velocity.x = EnemyData.SPEED

func _physics_process(delta: float) -> void:
	EnemyData.ray_movement(enemy, $RayLeft, $RayRight)
	
	EnemyData.animation(enemy)
	
	$Animator.play(EnemyData.current_animation)

func _on_detection_radius_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		if EnemyData.attacking == 1:
			EnemyData.speed = EnemyData.SPEED
		EnemyData.speed *= 1.2


func _on_hitbox_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.attacking = 1
		EnemyData.damage(enemy_damage)


func _on_hitbox_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.attacking = 0
		velocity.x = EnemyData.speed
