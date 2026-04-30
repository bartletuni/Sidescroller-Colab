extends PointLight2D

@export var max_flashlight_distance: float = 140.0
@export var base_texture_length: float = 750.0 # Adjust this based on your texture's default reach
@export var min_spot_scale: float = 0.4
@export var max_spot_scale: float = 1.0
@export var min_spot_energy: float = 0.5
@export var max_spot_energy: float = 2.5

@onready var body_light: PointLight2D = $"."
@onready var flashlight_ray: RayCast2D = $"../FlashlightRay"
@onready var player: CharacterBody2D = $".."
@onready var illumination_point: PointLight2D = $"../IlluminationPoint"

var flashlight_on: bool = true

func _ready() -> void:
	pass
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Flashlight"):
		toggle_flashlight()
		
	if flashlight_on:
		var mouse_pos = get_global_mouse_position()
		var player_pos = player.global_position
		
		# Look towards the mousea
		body_light.look_at(mouse_pos)
		
		var distance_to_mouse = player_pos.distance_to(mouse_pos)
		var direction = (mouse_pos - player_pos).normalized()
		
		# Clamp the distance to max allowed distance
		var target_distance = min(distance_to_mouse, max_flashlight_distance)
		
		# Calculate target point in world coordinates
		var target_pos = player_pos + direction * target_distance
		
		# Use the raycast to check for collisions
		# target_position is relative to the raycast's position
		flashlight_ray.target_position = flashlight_ray.to_local(target_pos)
		flashlight_ray.force_raycast_update()
		
		var final_pos = target_pos
		var final_distance = target_distance
		
		if flashlight_ray.is_colliding():
			final_pos = flashlight_ray.get_collision_point()
			final_distance = player_pos.distance_to(final_pos)
			
		# Update illumination point
		illumination_point.global_position = final_pos
		
		# Dynamically scale the beam to stretch to the final distance
		# Adjust the scale to make it stretch, maintaining proportions
		body_light.texture_scale = final_distance / base_texture_length
		
		# Calculate how close we are to the max distance (0.0 = close, 1.0 = far)
		var distance_factor = clamp(final_distance / max_flashlight_distance, 0.0, 1.0)
		
		# Shrink/brighten when closer, grow/dim when farther
		illumination_point.texture_scale = lerp(min_spot_scale, max_spot_scale, distance_factor)
		illumination_point.energy = lerp(max_spot_energy, min_spot_energy, distance_factor)

func toggle_flashlight():
	flashlight_on = !flashlight_on
	body_light.visible = flashlight_on
	illumination_point.visible = flashlight_on
