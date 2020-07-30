extends VBoxContainer

var my_player_info = { #TODO: Move from lobby scene to playerstatistics
	display_name = "Player Test",
	colour = Color("ff0000"),
}

var level_idx: int # index of level_list

onready var player_list_box = $MainPanel/PlayerList
onready var start_button = $StartButton

onready var map_selector = $"MainPanel/MatchInfo/MapSelector"
onready var level_list := [
	"res://levels/test_level_without_player.tscn",
]


func _ready() -> void:
	if not get_tree().has_network_peer():
		go_back_to_prelobby()
	
	# TEMP
	my_player_info.display_name = str(Network.self_id)
	
	if not Network.is_host:
		start_button.disabled = true
	
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	populate_level_dropdown()
	
	add_to_player_list(my_player_info) # Add self to player list


func go_back_to_prelobby() -> void:
	if get_tree().change_scene("res://menu/prelobby.tscn"):
		if OS.is_debug_build():
			print("Prelobby scene is broken")


func add_to_player_list(new_player_info: Dictionary) -> void:
	var label = Label.new()
	label.text = new_player_info.display_name
	player_list_box.add_child(label)
	print(Network.peer_list)


func populate_level_dropdown():
	for item in level_list:
		map_selector.add_item(item)


remote func register_player(player_info: Dictionary) -> void:
	var sender_id = get_tree().get_rpc_sender_id()
	print(sender_id)
	Network.peer_list[sender_id] = player_info
	add_to_player_list(player_info)


func _peer_connected(id: int) -> void:
	# When a new player connects, tell that player this client exists
	# TODO: Move client database to server
	if OS.is_debug_build():
		print("Peer {%d} connected" % id)
	rpc_id(id, "register_player", my_player_info)


func _peer_disconnected(id: int) -> void:
	if OS.is_debug_build():
		print("Peer {%d} disconnected" % id)
	Network.peer_list.erase(id)


func _connection_failed() -> void:
	if OS.is_debug_build():
		print("Connection failed")
	# TODO: Show popup
	go_back_to_prelobby()


func _server_disconnected() -> void:
	if OS.is_debug_build():
		print("Server disconnected")
	# TODO: Show popup
	go_back_to_prelobby()


remotesync func start_level(level_idx):
	GameLoader.configure_level(level_idx)
	self.queue_free()


func _on_StartButton_pressed() -> void:
	rpc("start_level", level_list[level_idx])
