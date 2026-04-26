extends CharacterBody2D

@onready var enemy: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator
@onready var PhysicsCrate = "res://Scripts/Object Scripts/PhysicsCrate.gd"
@onready var health_bar: ProgressBar = $HealthBar
@onready var hitbox: Area2D = $hitbox
@onready var hitbox_shape: CollisionShape2D = $hitbox/hitbox_shape

var enemy_damage = 1

func _ready() -> void:
	EnemyData.health = EnemyData.HEALTH
	EnemyData.dying = false
	EnemyData.attacking = 0
	EnemyData.chasing = false
	EnemyData.player_within_hitbox = false
	EnemyData.attack_loop_running = false
	EnemyData.hitbox_resetting = false
	EnemyData.walk()
	velocity.x = EnemyData.speed

func _physics_process(delta: float) -> void:
	if abs(EnemyData.enemy_x_position - PlayerData.player_x_position) <= 10 and not abs(EnemyData.enemy_y_position - PlayerData.player_y_position) > 64:
		velocity.x += 100
	
	EnemyData.death(enemy, animator)
	
	EnemyData.facing($Animator)
	
	EnemyData.orientation($Animator)
	
	EnemyData.tracking(enemy)
	
	EnemyData.ray_movement(enemy, delta, $RayLeft, $RayRight)
	
	EnemyData.animation(enemy)
	
	WorldData.gravity(enemy, delta)
	
	$Animator.play(EnemyData.current_animation)
	
	EnemyData.health_bar(health_bar)

func _on_hitbox_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if "Objects" in groups:
		EnemyData.kicking = randf()
		EnemyData.within = true
		if EnemyData.kicking > 0.65:
			EnemyData.attacking = 1
			await get_tree().create_timer(0.3).timeout
			EnemyData.attacking = 0
		
	if EnemyData.within and EnemyData.kicking < 0.65:
		EnemyData.jump(enemy)

func _on_detection_radius_area_entered(area: Area2D) -> void:
	pass

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
		EnemyData.player_within_hitbox = true
		if not EnemyData.attack_loop_running:
			EnemyData.attack_player(hitbox, hitbox_shape, enemy_damage)

func _on_hitbox_body_exited(body: Node2D) -> void:
	var groups = body.get_groups()
	if "Players" in groups and not EnemyData.hitbox_resetting:
		EnemyData.player_within_hitbox = false
		EnemyData.attacking = 0

func _on_hitbox_area_exited(area: Area2D) -> void:
	var groups = area.get_groups()
	if "Objects" in groups:
		EnemyData.within = false

func _on_damagebox_area_entered(area: Area2D) -> void:
	var group = area.get_groups()
	if "PlayerAttack" in group:
		EnemyData.health -= 1
