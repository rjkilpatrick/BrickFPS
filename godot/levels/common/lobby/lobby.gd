extends VBoxContainer

onready var player_list = $MainPanel/PlayerList


func _ready() -> void:
	if get_tree().has_network_peer():
		print("HAS PEER")
		pass
