class_name Actor
extends KinematicBody

# -----------------------
# Networking
var is_network_master: bool
var is_online: bool


func _ready() -> void:
	is_online = get_tree().has_network_peer()
	is_network_master = is_network_master()


func _physics_process(delta: float) -> void:
	pass
