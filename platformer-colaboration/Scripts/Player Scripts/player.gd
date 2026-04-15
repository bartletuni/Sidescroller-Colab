extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator
@onready var health_bar: ProgressBar = $HealthBar

func _physics_process(delta: float) -> void:
	
	PlayerData.movement_input()
	
	PlayerData.gravity(player, delta)
	
	PlayerData.player_movement(player, delta, PlayerData.direction, PlayerData.sprint, PlayerData.slide, PlayerData.crouch, PlayerData.jump)
	
	PlayerData.animator(player)
	
	PlayerData.healthbar(health_bar)
	
	if PlayerData.health == 0:
		player.queue_free()
		PlayerData.health = 10
		WorldData.reload()
	
	if animator.animation != PlayerData.current_animation:
		$Animator.play(PlayerData.current_animation)
