# Game Manager
# Launches game
extends Node

var players_configured := []
var level: Node

# -----------------
# Loading game
remote func configure_level(which_level: String):
	# Run on each client
	get_tree().set_pause(true)
	
	# Load level
	level = load(which_level).instance() #TODO: Validation checking
	get_tree().get_root().add_child(level)
	var player_spawn = level.get_node("Players")
	
	# Load player
	var my_player = load("res://player/player.tscn").instance()
	my_player.set_network_master(Network.self_id)
	my_player.set_name(str(Network.self_id))
	player_spawn.add_child(my_player)
	
	# Load actors
	var actor_scene = load("res://actor/puppet_player.tscn")
	for id in Network.peer_list:
		var actor = actor_scene.instance()
		actor.set_network_master(id)
		actor.set_name(str(id))
		player_spawn.add_child(actor)
	
	
	rpc_id(Network.SERVER_ID, "done_configuring")
	
	if OS.is_debug_build():
		print(str(Network.self_id) + " finished configuring")


master func done_configuring():
	# Called on server, postconfigures game when all ready
	var who = get_tree().get_rpc_sender_id()
	players_configured.append(who)
	
	if players_configured.size() == Network.peer_list.size() + 1: # Server is client
		# All finished loading
		if OS.is_debug_build():
			print("All finished configuring")
		rpc("post_configure_game")


remotesync func post_configure_game():
	get_tree().set_pause(false)
	
	if has_node("../Lobby"): # FIXME: Hardcoded
		get_node("../Lobby").queue_free()

# -----------------
# During game

# -----------------
# End game
