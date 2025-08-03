extends CharacterBody3D

# speed related normal properties
@export var SPEED := 0.5

@export_group("Input_Actions")
@export var input_left := "ui_left"
@export var input_right := "ui_right"
@export var input_forward := "ui_up"
@export var input_backward := "ui_down"




func _physics_process(delta: float) -> void:
	
	
	var move_vector := _get_input_vector()
	if move_vector != Vector3.ZERO:
		move_and_collide(move_vector * delta * SPEED)
		$CSGSphere3D.rotate(_get_input_rotation_vector(),0.2)

func _get_input_vector() -> Vector3:
	var vector := Vector3.ZERO

	if Input.is_action_pressed(input_forward):
		vector += Vector3.FORWARD
	if Input.is_action_pressed(input_backward):
		vector += Vector3.BACK
	if Input.is_action_pressed(input_left):
		vector += Vector3.LEFT
	if Input.is_action_pressed(input_right):
		vector += Vector3.RIGHT
	return vector.normalized()


func _get_input_rotation_vector() -> Vector3:
	var vector := Vector3.ZERO

	if Input.is_action_pressed(input_forward):
		vector += Vector3.LEFT
	if Input.is_action_pressed(input_backward):
		vector += Vector3.RIGHT
	if Input.is_action_pressed(input_left):
		vector += Vector3.BACK
	if Input.is_action_pressed(input_right):
		vector += Vector3.FORWARD
	return vector.normalized()
