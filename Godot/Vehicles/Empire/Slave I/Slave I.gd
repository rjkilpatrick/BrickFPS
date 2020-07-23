"""
Slave I controls.

TODO:
	Refactor into general starfighter script
"""

extends KinematicBody

enum {LANDED, FLYING, LAUNCHING, LANDING}

var state = null

onready var land_cast = $LandCast

const LAND_SPEED = 20
const LAUNCH_SPEED = 20

onready var land_height = land_cast.cast_to.length()

func _ready():
	state = LANDED


func _physics_process(delta):
	match state:
		LANDING:
			translate(Vector3.DOWN * lerp(0, land_height, LAND_SPEED * delta))
			pass
			# Abort Landing
		LAUNCHING:
			translate(Vector3.UP * lerp(land_height, 0, LAND_SPEED * delta))
			pass
			# Abort Launching
			# Move ship up 20
			# Move camera up 10
		LANDED:
			pass
			# TODO:
			# Accept players entering
				# Make camera current
				# Disable player controls
			# "interact"
			# Pilot can launch vehicle
		FLYING:
			pass
			
			# TODO:
			# W - accelerate
			# S - deaccelerate
			# R - Reload
			# Mouse left-right == yaw
			# Mouse up-down == pitch
			# if action pressed land
			land_cast.force_raycast_update()
			
			if land_cast.is_colliding():
				land()

func land():
	pass


func launch():
	pass


func enter_vehicle():
	pass
