extends Actor

var paused = false

# -----------------------
# Movement
enum { # TODO: Implement movement state machine
	IDLE,
	WALK,
	SPRINT,
	CROUCH,
	JUMP,
}

var move_state = IDLE

var target_direction = Vector3.ZERO
var hvel = Vector3.ZERO

# -----------------------
# Camera controls
export var DEFAULT_MOUSE_SENSITIVITY = 0.1
var _mouse_sensitivity = DEFAULT_MOUSE_SENSITIVITY
onready var camera_target = $"CameraTarget"
onready var camera = $"CameraTarget/Camera"

var mouse_captured = false

# -----------------------
# Weapons

# -----------------------
# UI


func _ready():
	._ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Handle character selected
	
	# Setup weapon points
	
	# Setup animation tree


func _process(delta: float) -> void:
	update_hud(delta)


func _physics_process(delta: float) -> void:
	process_input(delta)
	process_movement(delta)
	
	if is_online:
		rset_unreliable("puppet_position", global_transform.origin)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", rotation)


func process_input(delta: float) -> void:
	# -----------------------
	# Movement
	var input_vector = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	input_vector = input_vector.normalized()
	
	# TODO: Add joystick movement input support
	target_direction = Vector3.ZERO
	target_direction += transform.basis.x * input_vector.x
	target_direction += transform.basis.z * input_vector.y
	
	# Jumping
	if Input.is_action_just_pressed("move_jump") and is_on_floor(): #or is_on_wall():
		velocity.y = JUMP_SPEED
		pass
		move_state = JUMP
	
	# Sprinting
	if Input.is_action_pressed("move_sprint") and is_on_floor():
		pass
		move_state = SPRINT
	
	# Crouching
	if Input.is_action_pressed("crouch"):
		pass
		move_state = CROUCH
	
	if Input.is_action_just_pressed("pause"):
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = not mouse_captured


func _input(event: InputEvent) -> void:
	# -----------------------
	# Mouse movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate around self when moving in viewport x-plane
		self.rotate_y(deg2rad(event.relative.x * _mouse_sensitivity * -1))
		# Rotate camera about gimbal (target) when mouse moves in y-plane
		camera_target.rotate_x(deg2rad(event.relative.y * _mouse_sensitivity * -1))
		camera_target.rotation.x = clamp(camera_target.rotation.x, -deg2rad(70), deg2rad(90))


func process_movement(delta: float) -> void:
	target_direction = target_direction.normalized()
	
	velocity += delta *  GRAVITY
	
	hvel = velocity
	hvel.y = 0
	
	var target = target_direction
	match move_state:
		SPRINT:
			target *= MAX_SPRINT_SPEED
		CROUCH:
			target *= MAX_SPRINT_SPEED
		_:
			target *= DEFAULT_MOVE_SPEED
	
	var acceleration = DEACCELERATION
	
	if target_direction.dot(hvel) > 0:
		match move_state:
			SPRINT:
				acceleration = SPRINT_ACCELERATION
			CROUCH:
				acceleration = CROUCH_MOVE_SPEED
			WALK:
				acceleration = WALK_ACCELERATION
	
	hvel = hvel.linear_interpolate(target, acceleration * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4)


func update_hud(delta: float) -> void:
	pass
