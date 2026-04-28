extends PointLight2D

@onready var body_light: PointLight2D = $"."
@onready var flashlight_ray: RayCast2D = $"../FlashlightRay"

var flashlight_on: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Toggle Flashlight"):
		toggle_flashlight()
	if flashlight_on == true:
		flashlight_ray.target_position = flashlight_ray.to_local(mouse_pos)
		flashlight_ray.force_raycast_update()
		
		if flashlight_ray.is_colliding():
			body_light.global_position = flashlight_ray.get_collision_point()
		else:
			body_light.global_position = mouse_pos


func toggle_flashlight():
	flashlight_on = !flashlight_on
	body_light.visible = flashlight_on
