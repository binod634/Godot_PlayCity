extends CharacterBody3D

# speed related normal properties
@export var SPEED := 0.25
@export var MOUSE_SENSATIVITY = 0.01

@onready var current_camera = $playercamera

@export_group("Input_Actions")
@export var input_left := "ui_left"
@export var input_right := "ui_right"
@export var input_forward := "ui_up"
@export var input_backward := "ui_down"
@export var input_shift := "key_shift"


# variables
var running = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	current_camera.current = is_multiplayer_authority()
	print("here in this ",name.to_int()," authority is: ",is_multiplayer_authority())
	if not is_multiplayer_authority():
		return
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		rotate_y(-event.relative.x * MOUSE_SENSATIVITY)
		#$playercamera.rotate_x(-event.relative.y * )
	#if event is InputEventScreenTouch:
		#_simulate_attack()
		





func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	if  Input.is_action_pressed("quit"):
		$"../".exit_game(name.to_int())
		
	
	var move_vector := _get_input_vector()
	if not is_on_floor():
		move_vector -= Vector3(0, 1.5, 0)




	if move_vector != Vector3.ZERO:
		if not $"character-a2/AnimationPlayer".is_playing():
			$"character-a2/AnimationPlayer".play("sprint" if running else "walk")

		# Move
		var direction = (transform.basis * move_vector)
		velocity = direction * SPEED
		velocity *=2.0 if running else 1.0
		move_and_slide()





		# We only want the Y-axis (horizontal turning)
		var flat_direction = move_vector
		flat_direction.y = 0
		if flat_direction.length() > 0.01:
			var target_angle = atan2(flat_direction.x, flat_direction.z)
			# Rotate the whole body
			$"character-a2".rotation.y = lerp_angle($"character-a2".rotation.y, target_angle, 5 * delta)
	else:
		if $"character-a2/AnimationPlayer".is_playing():
			$"character-a2/AnimationPlayer".stop()
		velocity = Vector3.ZERO
		
		





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

	vector = vector.normalized()

	if Input.is_action_pressed(input_shift):
		print("git shift")
		running = true
	else:
		running = false

	return vector






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
