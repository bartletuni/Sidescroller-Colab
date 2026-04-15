extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator

func _physics_process(delta: float) -> void:
	
	PlayerData.movement_input()
	
	PlayerData.gravity(player, delta)
	
	PlayerData.player_movement(player, delta, PlayerData.direction, PlayerData.sprint, PlayerData.slide, PlayerData.crouch, PlayerData.jump)
	
	PlayerData.animator(player)
	
	if animator.animation != PlayerData.current_animation:
		$Animator.play(PlayerData.current_animation)
