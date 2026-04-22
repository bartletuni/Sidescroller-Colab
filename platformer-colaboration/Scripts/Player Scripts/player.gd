extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator
@onready var health_bar: ProgressBar = $HealthBar
@onready var detector: Area2D = $Detector
@onready var attackbox_left: CollisionShape2D = $AttackBox/attackbox_left
@onready var attackbox_right: CollisionShape2D = $AttackBox/attackbox_right

func _physics_process(delta: float) -> void:
	PlayerData.areas_in(detector)
	
	PlayerData.tracking(player)
	
	PlayerData.movement_input()
	
	PlayerData.attack(attackbox_left, attackbox_right)
	
	WorldData.gravity(player, delta)
	
	PlayerData.player_movement(player, delta, PlayerData.direction, PlayerData.sprint, 
	PlayerData.slide, PlayerData.crouch, PlayerData.jump, PlayerData.climb)
	
	PlayerData.animator(player)
	
	PlayerData.healthbar(health_bar)
	
	if PlayerData.health == 0:
		player.queue_free()
		PlayerData.health = 10
		WorldData.reload()
	
	if animator.animation != PlayerData.current_animation:
		$Animator.play(PlayerData.current_animation)
