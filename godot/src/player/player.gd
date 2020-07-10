extends KinematicBody

var paused = false

# -----------------------
# Movement

onready var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")
export var DEFAULT_MOVE_SPEED = 10
onready var JUMP_SPEED = 0.5 * ProjectSettings.get_setting("physics/3d/default_gravity")
const ACCELERATION = 10
const DEACCELERATION = 10

var target_direction = Vector3.ZERO
var velocity = Vector3.ZERO
var hvel = Vector3.ZERO

# -----------------------
# Camera controls
export var DEFAULT_MOUSE_SENSITIVITY = 0.1
var MOUSE_SENSITIVITY = 0.1
onready var camera_target = $"CameraTarget"
onready var camera = $"CameraTarget/Camera"

# -----------------------
# Properties
export var MAX_HEALTH = 150
export var health = 100

# -----------------------
# Weapons

# -----------------------
# UI

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Handle character selected
	
	# Setup weapon points
	
	# Setup animation tree


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_UI(delta)


func process_input(delta):
	# -----------------------
	# Movement
	var input_vector = Vector2(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward"))
	input_vector = input_vector.normalized()
	
	# TODO: Add joystick movement input support
	target_direction = Vector3.ZERO
	target_direction += transform.basis.x * input_vector.x
	target_direction += transform.basis.z * input_vector.y
	
	# Jumping
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_SPEED


func _input(event):
	# -----------------------
	# Mouse movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate around self when moving in viewport x-plane
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		# Rotate camera about gimbal (target) when mouse moves in y-plane
		camera_target.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		camera_target.rotation.x = clamp(camera_target.rotation.x, -deg2rad(70), deg2rad(90))


func process_movement(delta):
	target_direction = target_direction.normalized()
	
	velocity += delta *  GRAVITY
	
	hvel = velocity
	hvel.y = 0
	
	var target = target_direction
	target *= DEFAULT_MOVE_SPEED
	
	var acceleration
	if target_direction.dot(hvel) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DEACCELERATION
	
	hvel = hvel.linear_interpolate(target, acceleration * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4)


func process_UI(delta):
	pass
