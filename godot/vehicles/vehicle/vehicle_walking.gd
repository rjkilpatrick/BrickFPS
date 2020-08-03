class_name VehicleWalking
extends "res://vehicles/vehicle/vehicle.gd"

var velocity := Vector3.ZERO

func _ready() -> void:
	pass


func process_input(delta: float) -> void:
	# -----------------------
	# Movement
	var input_vector = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	input_vector = input_vector.normalized()
	
	# TODO: Add joystick movement input support
	var target_direction = Vector3.ZERO
	target_direction += transform.basis.x * input_vector.x
	target_direction += transform.basis.z * input_vector.y


func process_movement(delta: float) -> void:
	pass
