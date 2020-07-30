# Simple networking implementation
# Creates a server or client on the local godot instance
# Handles peer connections etc.
#
# Adapted from code (c) Juan Linietsky, Ariel Manzur and the Godot community; revision 38a49756
# https://docs.godotengine.org/en/3.2/tutorials/networking/high_level_multiplayer.html
# [CC-BY 3.0](https://creativecommons.org/licenses/by/3.0/).
extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 31400
const SERVER_ID = 1 # Server ID is always 1 in NetworkedMultiplayerENet

var is_host = false
var self_id

var peer_list = {}


func create_server(port := DEFAULT_PORT, max_players := 32) -> int:
	# Creates a server
	# Returns `OK` if created
	is_host = true
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(port, max_players)
	if err == OK:
		get_tree().network_peer = peer
		self_id = get_tree().get_network_unique_id()
		assert(get_tree().is_network_server())
	return err


func create_client(server_ip := "127.0.0.1", port := DEFAULT_PORT) -> int:
	# Joins a pre-existing server as a client
	# Returns `OK` if created
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(server_ip, port)
	if err == OK:
		get_tree().network_peer = peer
		self_id = get_tree().get_network_unique_id()
		assert(not get_tree().is_network_server())
	return err
