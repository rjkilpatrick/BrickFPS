class_name VehicleWalking
extends "res://vehicles/vehicle/vehicle.gd"

onready var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity") \
		* ProjectSettings.get_setting("physics/3d/default_gravity_vector")
export var DEFAULT_MOVE_SPEED = 5.0
const WALK_ACCELERATION = 10
const DEACCELERATION = 10

var velocity := Vector3.ZERO
var hvel := Vector3.ZERO

var target_direction := Vector3.ZERO

onready var pilot = $PlayerPositionHolder/DrivingPosition


func _ready() -> void:
	._ready()


func _physics_process(delta: float) -> void:
	._physics_process(delta)


func process_input(_delta: float) -> void:
	if pilot.has_player:
		# -----------------------
		# Movement
		var input_vector = Vector2(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
				Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
		input_vector = input_vector.normalized()
		
		# TODO: Add joystick movement input support
		target_direction = Vector3.ZERO
		# Turns easy vertically, very very hard to spin
		target_direction += transform.basis.x * input_vector.x
		target_direction += transform.basis.z * input_vector.y


func process_movement(delta: float) -> void:
#	velocity += delta * GRAVITY
	
	if pilot.has_player:
		target_direction = target_direction.normalized()
		
		
		hvel = velocity
		hvel.y = 0
		
		var target = target_direction
		target *= DEFAULT_MOVE_SPEED
		
		var acceleration = DEACCELERATION
		
		if target_direction.dot(hvel) > 0:
			acceleration = WALK_ACCELERATION
		
		hvel = hvel.linear_interpolate(target, acceleration * delta)
		velocity.x = hvel.x
		velocity.z = hvel.z
		
	velocity = move_and_slide(velocity, Vector3.UP, true, 4)
