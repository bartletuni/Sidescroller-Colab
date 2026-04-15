extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animation: AnimatedSprite2D = $Animation

func _physics_process(delta: float) -> void:
	
	PlayerData.movement_input()
	
	PlayerData.gravity(player, delta)
	
	PlayerData.player_movement(player, delta, PlayerData.direction, PlayerData.sprint, PlayerData.slide, PlayerData.crouch, PlayerData.jump)
	
	PlayerData.animator(player)
	
	if animation.animation != PlayerData.current_animation:
		$Animation.play(PlayerData.current_animation)
