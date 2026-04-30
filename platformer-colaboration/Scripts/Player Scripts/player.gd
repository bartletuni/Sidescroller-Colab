extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $Animator
@onready var health_bar: ProgressBar = $HealthBar
@onready var detector: Area2D = $Detector
@onready var attackbox_left: CollisionShape2D = $AttackBox/attackbox_right
@onready var attackbox_right: CollisionShape2D = $AttackBox/attackbox_left


func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	
	PlayerData.areas_in(detector)
	
	PlayerData.tracking(player)
	
	PlayerData.movement_input()
	
	PlayerData.attack(attackbox_left, attackbox_right)
	
	WorldData.gravity(player, delta)
	
	PlayerData.player_movement(player, delta)
	
	PlayerData.animator(player)
	
	PlayerData.healthbar(health_bar)
	
	if PlayerData.health == 0:
		player.queue_free()
		PlayerData.health = 10
		WorldData.reload()
	
	if mouse_position.x > PlayerData.player_x_position:
		animator.flip_h = false
	elif mouse_position.x < PlayerData.player_x_position:
		animator.flip_h = true
