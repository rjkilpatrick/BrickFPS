extends Tabs

onready var join_address = $JoinAddress
onready var join_status = $JoinStatus

var _server_is_connected = false


func _ready() -> void:
	join_address.text = IP.get_local_addresses()[0] # TODO: Remove magic number
	get_tree().connect("connected_to_server", self, "_connected_to_server")


func _connected_to_server() -> void:
	if OS.is_debug_build():
		print("Connected to server")
	_server_is_connected = true


func _on_JoinButton_pressed() -> void:
	var ip_address = join_address.text
	join_status.text = "Attempting to connect to " + ip_address
	
	if not ip_address.is_valid_ip_address():
		join_status.text = ip_address + " is not a valid IP address"
		return
	
	var err = Network.create_client(ip_address)
	match err:
		OK:
			#TODO: Add waiting screen until server connects
			if get_tree().change_scene("res://menu/lobby.tscn") != OK:
				join_status.text = "Lobby scene is broken."
		ERR_ALREADY_IN_USE:
			join_status.text = "You are already connected to server, please " \
					+ "disconnect and try again."
		ERR_CANT_CREATE:
			join_status.text = "A client could not be created."
		_:
			join_status.text = "An unknown error is preventing you from" \
					+ " connecting to the server"
