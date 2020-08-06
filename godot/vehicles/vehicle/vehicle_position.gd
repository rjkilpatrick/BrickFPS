class_name VehiclePosition
extends Position3D
# Can contain one player
# Sets sitting animation on player
# Camera moves around this point

var player: KinematicBody = null#setget _set_player
var has_player := false
onready var camera_target = $CameraTarget
onready var camera = $CameraTarget/Camera
export var can_move = false

onready var root = get_parent().get_parent()


func _ready() -> void:
	pass


func set_player(new_player: KinematicBody) -> void:
	if new_player == player:
		return
	
	if player:
		player.queue_free()
	
	if new_player:
		add_child(new_player)
		has_player = true
	
	player = new_player


func clear_player() -> void:
	player.queue_free()
	has_player = false


func _input(event: InputEvent) -> void:
	# -----------------------
	# Mouse handling
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate around root when moving in viewport x-plane
		root.rotate_y(deg2rad(event.relative.x * .001 * -1)) # FIXME: Mouse sensitivity hard-coded
		# Rotate camera about gimbal (target) when mouse moves in y-plane
		camera_target.rotate_x(deg2rad(event.relative.y * .1 * -1)) # FIXME: Mouse sensitivity hard-coded
		camera_target.rotation.x = clamp(camera_target.rotation.x, -deg2rad(70), deg2rad(90))
