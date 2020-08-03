extends KinematicBody
# A vehicle is any moving body that a player can enter
# A player can move to any of the empty VehiclePosition


export var max_players = 1
var _player_list = []
var _current_player = null


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	process_input(delta)
	process_movement(delta)


func process_input(delta):
	pass


func process_movement(delta):
	pass


func interact(player: KinematicBody) -> void:
	_enter_vehicle(player)


func _enter_vehicle(player: KinematicBody) -> void:
	print("ATTEMPT TO ENTER")
	if _player_list.size() >= max_players:
		print("VEHICLE FULL")
		return
	_player_list.append(player)
	player.set_process(false)
	player.set_physics_process(false)
	player.set_process_input(false)
	add_child(player)
	player.owner = self


func _leave_vehicle(index: int) -> void:
	var player = _player_list[index]
	
	# Get suitable postion for player
	var vehicle_position = global_transform.origin
	var position_in_plane = Vector3(rand_range(-10, 10), 0, rand_range(-10, 10))
	self.remove_child(_player_list[index])
	
	player.global_transform.origin = vehicle_position + position_in_plane
	_player_list.remove(index)
	get_tree().add_child(player)
	player.set_process(true)
	player.set_physics_process(true)
	player.set_process_input(true)
