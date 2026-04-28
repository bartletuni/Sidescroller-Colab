extends PointLight2D

@onready var body_light: PointLight2D = $"."
@onready var flashlight_ray: RayCast2D = $"../FlashlightRay"
@onready var player: CharacterBody2D = $".."

var flashlight_on: bool = true

func _ready() -> void:
	#if flashlight_on == true:
		#body_light.position.y -= 100
	pass
		
func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Toggle Flashlight"):
		toggle_flashlight()
	#if flashlight_on == true:
		#body_light.position.y -= 100
		#flashlight_ray.look_at(mouse_pos)
		#flashlight_ray.force_raycast_update()
		#
		#if flashlight_ray.is_colliding():
			#body_light.global_position = flashlight_ray.get_collision_point()
		
	body_light.look_at(mouse_pos)


func toggle_flashlight():
	flashlight_on = !flashlight_on
	body_light.visible = flashlight_on
