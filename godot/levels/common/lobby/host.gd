extends Tabs

onready var host_ip = $HostIP
onready var host_status = $HostingStatus

var ip = IP.get_local_addresses()[0]

func _ready() -> void:
	host_ip.text = IP.get_local_addresses()[0] # TODO: Remove magic number


func _on_HostButton_pressed() -> void:
	host_status.text = "Attempting to host server on " + ip
	var err = Network.create_server()
	match err:
		OK:
			print("Server running on " + ip)
			get_tree().change_scene("res://levels/common/lobby/lobby.tscn")
		_:
			host_status.text = "Unable to create server on " + ip + " for an " \
					+ "unknown reason."
