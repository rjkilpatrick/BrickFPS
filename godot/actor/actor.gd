class_name Actor
extends KinematicBody


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	rpc_unreliable("update_position")


remote func update_position(new_position):
	pass
