extends Actor

# -----------------------
# Movement
var hvel: Vector3

## -----------------------
## Behaviour
#enum Behaviour {
#	CHASE,
#	HIDE,
#	CAPTURE_OBJECTIVE,
#	CHASE,
#}
#
#var behaviour_state = Behaviour.CHASE

# -----------------------
# Navigating
var is_navigating := false
var navigation: Navigation
var path: PoolVector3Array
var target_position: Vector3
var target_node: Spatial


func _ready():
	._ready()
	yield(get_tree().create_timer(1.0), "timeout") # Temporary whilst testing
	target_position = global_transform.origin
	set_target_position(Vector3.ZERO)


func _physics_process(delta: float) -> void:
	if is_navigating:
		move_to_target(delta)
	
	if is_online:
		rset_unreliable("puppet_position", global_transform.origin)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", rotation)


func move_to_target(delta: float) -> void:
	if path:
		if path.size() >= 2:
			var move_distance = path[1] - global_transform.origin
			
			move_distance.y = 0
			
			velocity = move_distance.normalized() * DEFAULT_MOVE_SPEED
			velocity += delta *  GRAVITY
			
			velocity = move_and_slide(velocity, Vector3.UP)
			
			if move_distance.length() < 0.1:
				path.remove(0)
#				if path.size() > 2:
#					look_at(path[1], Vector3.UP)
#				else:
#					look_at(target_position, Vector3.UP)
		else:
			is_navigating = false
			path = PoolVector3Array()
	else:
		is_navigating = false


func set_target_position(new_target_position: Vector3) -> void:
	# Global space
	if navigation:
		if new_target_position.distance_to(target_position) >= 0.1:
			print("TARGET SET")
			target_position = navigation.get_closest_point(new_target_position)
			var position = navigation.get_closest_point(global_transform.origin)
			path = Array(navigation.get_simple_path(position, target_position))
			
			is_navigating = true
#			look_at(path[1], Vector3.UP)


func set_target(node: Spatial) -> void:
	if node:
		target_node = node
		set_target_position(node.get_global_transform().origin)


func _on_ai_tick() -> void:
	print("Y: ", global_transform.origin.y)
	set_target($"../Player") # TEMP
	pass
#	set_target_position(Vector3.ZERO) # TEMP
	# Consider changing state
