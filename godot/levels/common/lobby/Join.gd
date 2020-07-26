extends Tabs

onready var join_address = $JoinAddress
onready var join_status = $JoinStatus


func _ready() -> void:
	pass


func _on_JoinButton_pressed() -> void:
	var ip_address = join_address.text
	join_status.text = "Attempting to connect to " + ip_address
	if not join_address.text.is_valid_ip_address():
		join_status.text = ip_address + " is not a valid IP address"
		return
	
	var err = Network.create_client(ip_address)
	match err:
		OK:
			if get_tree().change_scene("res://levels/common/lobby/lobby.tscn") != OK:
				join_status.text = "Lobby scene is broken"
		ERR_ALREADY_IN_USE:
			join_status.text = "You are already connected to server, please " \
					+ "disconnect and try again"
		ERR_CANT_CREATE:
			join_status.text = "A client could not be created, likely because" \
					+ " you couldn't connect to the server"
		_:
			join_status.text = "An unknown error is preventing you from" \
					+ " connecting to the server"
