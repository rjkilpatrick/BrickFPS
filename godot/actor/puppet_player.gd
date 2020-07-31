#Networked player dislay
extends Actor

puppet var puppet_velocity := Vector3.ZERO
puppet var puppet_rotation := rotation


func _ready() -> void:
	._ready()


func _physics_process(delta: float) -> void:
	puppet_velocity = move_and_slide(puppet_velocity, Vector3.UP, true, 4)
	rotation = puppet_rotation
