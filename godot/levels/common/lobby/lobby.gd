extends VBoxContainer

onready var player_list_box = $MainPanel/PlayerList
onready var start_button = $StartButton

var my_player_info = { #TODO: Move from lobby scene to playerstatistics
	display_name = "Player Test",
	colour = Color("ff0000"),
}

var which_level = null


func _ready() -> void:
	if not get_tree().has_network_peer():
		go_back_to_prelobby()
	
	# TEMP
	my_player_info.display_name = str(Network.self_id)
	
	if not Network.is_host:
		start_button.disabled = true
	
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	add_to_player_list(my_player_info) # Add self to player list


func go_back_to_prelobby() -> void:
	if get_tree().change_scene("res://levels/common/lobby/prelobby.tscn"):
		if OS.is_debug_build():
			print("Prelobby scene is broken")


func add_to_player_list(new_player_info: Dictionary) -> void:
	var label = Label.new()
	label.text = new_player_info.display_name
	player_list_box.add_child(label)
	print(Network.peer_list)


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


func _connected_to_server() -> void:
	if OS.is_debug_build():
		print("Connected to server")


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
## Populate PlayerList
#func update_player_list() -> void:
#	for id in player_list:
##		var new_player = Node()
##		player_list_box.add_child(new_player)
#		print("Name: " + String(player_list[id].name))
#
#
#remote func register_player(info: Dictionary):
#	# id of remote caller
#	var id = get_tree().get_rpc_sender_id()
#
#	player_list[id] = info
#
#	update_player_list()
#
#func _on_StartButton_pressed() -> void:
#	get_tree().set_refuse_new_network_connections(true)
#
#
#func _player_connected(id: int) -> void:
#	# When another peer connects, tell them about this client
#	print("SOMEONE ELSE HAS BECOME A PEER :O")
#	rpc_id(id, "register_player", my_info)
#
#	update_player_list()
#
#
##remote func pre_configure_game():
#	get_tree().set_pause(true) # Pause until everyone is loaded
#
#	var self_peer_id = get_tree().get_network_unique_id()
#
#	# Load world
#	var world = load(which_level).instance()
#	get_tree().add_child(world)
#
#	# Load own player
#	var own_player = preload("res://player/player.tscn").instance()
#	own_player.set_name(str(self_peer_id))
#	own_player.set_network_master(self_peer_id)
#	world.add_child(own_player)
#
#	# Load other players
#	for p in player_list:
#		var npc = preload("res://actor/npc_actor.tscn").instance()
#		npc.set_name(str(p))
#		npc.set_network_master(p)
#		world.add_child(npc)
#
#	rpc_id(1, "finished_preconfiguration", self_peer_id)
#
#
#var players_preconfigured = []
#remote func finished_preconfiguration(who):
#	players_preconfigured.append(who)
#
#	if players_preconfigured.size() >= player_list.size():
#		rpc("post_configure_game")
#
#remote func post_configure_game():
#	get_tree().set_pause(false)
#	# Game begins


func _on_StartButton_pressed() -> void:
	if Network.is_host:
		pass
