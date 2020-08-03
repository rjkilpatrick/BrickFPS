extends Spatial

onready var players_container = $Players
onready var navigation = $Navigation


func _ready() -> void:
	for player in players_container.get_children():
		if "navigation" in player:
			player.navigation = navigation
