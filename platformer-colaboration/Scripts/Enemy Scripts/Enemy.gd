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

func _on_hitbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if "Players" in groups:
		EnemyData.damage(enemy_damage)

func _on_detection_radius_area_entered(area: Area2D) -> void:
	pass


func _on_detection_radius_body_entered(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups:
		EnemyData.run(enemy)
	else:
		print(groups)
