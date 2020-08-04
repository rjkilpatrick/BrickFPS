class_name Actor
extends KinematicBody

# -----------------------
# Movement
onready var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity") \
		* ProjectSettings.get_setting("physics/3d/default_gravity_vector")
export var DEFAULT_MOVE_SPEED = 5.0
const WALK_ACCELERATION = 10
const DEACCELERATION = 10

onready var JUMP_SPEED = 0.5 * ProjectSettings.get_setting("physics/3d/default_gravity")

onready var MAX_SPRINT_SPEED = DEFAULT_MOVE_SPEED * 1.5
const SPRINT_ACCELERATION = WALK_ACCELERATION * 1.5

onready var CROUCH_MOVE_SPEED = DEFAULT_MOVE_SPEED * 0.6
const CROUCH_ACCELERATION = WALK_ACCELERATION

# TODO: Add terminal velocity

var velocity = Vector3.ZERO

# -----------------------
# Networking
var is_network_master: bool
var is_online: bool

# -----------------------
# Properties
export var MAX_HEALTH = 150
export var health = 100


func _ready() -> void:
	is_online = get_tree().has_network_peer()
	if is_online:
		is_network_master = is_network_master()


func _physics_process(delta: float) -> void:
	pass
