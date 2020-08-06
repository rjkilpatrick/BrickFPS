extends KinematicBody
# A vehicle is any moving body that a player can enter
# A player can move to any of the empty VehiclePosition


var max_players := 1
var _player_list := []
var _positions := {}

onready var position_holder = $PlayerPositionHolder


func _ready() -> void:
	# Set available slots
	for position in position_holder.get_children():
		if position is VehiclePosition:
			_positions[position] = null
	max_players = _positions.size()


func _physics_process(delta: float) -> void:
	process_input(delta)
	process_movement(delta)


func process_input(_delta):
	pass


func process_movement(_delta):
	pass


# -----------------------
# Entering Vehicle
func interact(player: KinematicBody) -> void:
	_enter_vehicle(player)


func _enter_vehicle(player: KinematicBody) -> void:
	var position = _get_available_position()
	if position == null:
		print(self.name + " is full.")
		return
	
	print("Entered: " + self.name)
	
#	player.set_process(false)
#	player.set_physics_process(false)
#	player.set_process_input(false)
	player.get_parent().remove_child(player)
	player.enter_vehicle()
	
	position.set_player(player)
	if position.has_node("CameraTarget/Camera"):
		position.get_node("CameraTarget/Camera").make_current()


func _get_available_position() -> VehiclePosition:
	for pos in _positions:
		if _positions[pos] == null:
			return pos
	return null


# -----------------------
# Leaving Vehicle
func _leave_vehicle(index: int) -> void:
	var player = _player_list[index]
	
	player.global_transform.origin = _get_player_spawn_position()
	_player_list.remove(index)
	self.remove_child(player)
	
	player.set_process(true)
	player.set_physics_process(true)
	player.set_process_input(true)
	
	get_tree().add_child(player) # TODO: Add to Players node
#	if "camera" in player:
#		player.camera.make_current()


func _get_player_spawn_position() -> Vector3:
	# Get suitable postion for player
	var vehicle_position = global_transform.origin
	var position_in_plane = Vector3(rand_range(-10, 10), 0, rand_range(-10, 10))
	return vehicle_position + position_in_plane
