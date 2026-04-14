extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animation: AnimatedSprite2D = $Animation

func _physics_process(delta: float) -> void:
	
	PlayerData.movement_input()
	
	PlayerData.gravity(player, delta)
	
	PlayerData.player_movement(player, PlayerData.direction, PlayerData.sprint, PlayerData.slide, PlayerData.crouch, PlayerData.jump)
	
	PlayerData.animator(player)
	
	$Animation.play(PlayerData.current_animation)
