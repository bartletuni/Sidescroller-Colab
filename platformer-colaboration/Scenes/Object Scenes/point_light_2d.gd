extends PointLight2D

@export var min_energy = 1.20
@export var max_energy = 2.00
@export var flicker_speed = 5.0

var target_energy = 1.0

func _ready() -> void:
	target_energy = energy

func _process(delta: float) -> void:
	if randf() < 0.10:
		target_energy = randf_range(min_energy, max_energy)
	
	energy = lerp(energy, target_energy, flicker_speed * delta)
	#var target_scale = randf_range(0.98, 1.02)
	#texture_scale = lerp(texture_scale, target_scale, flicker_speed * delta)
