extends PointLight2D

@onready var body_light: PointLight2D = $"."

var flashlight_on: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Flashlight"):
		toggle_flashlight()
	if flashlight_on == true:
		global_position = get_global_mouse_position()


func toggle_flashlight():
	flashlight_on = !flashlight_on
	body_light.visible = flashlight_on
