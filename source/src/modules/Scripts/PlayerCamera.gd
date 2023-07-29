extends Camera3D

@export var cameraHolder: Node3D;
var lookSens: float = ProjectSettings.get_setting("player/look_sensitivity");

func _process(_delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _input(event):
	if(event is InputEventMouseMotion):
		cameraHolder.rotate_y(deg_to_rad(-event.relative.x * lookSens));
		rotate_x(deg_to_rad(-event.relative.y * lookSens));
		rotation.x = clamp(rotation.x, -PI * 0.5, PI * 0.5);
	if(event is InputEventMouseButton):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
