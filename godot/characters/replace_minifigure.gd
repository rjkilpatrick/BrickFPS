tool
extends Spatial

export(PackedScene) var minifigure = preload("res://assets/third_party/ldraw/minifigures/minifigure/minifigure.gltf") setget _minicharacter_set

var character_node: Spatial

func _ready() -> void:
	self.minifigure = minifigure


func _minicharacter_set(new_minifigure: PackedScene) -> void:
	print(new_minifigure, character_node)
#	if true:#Engine.is_editor_hint():
	if has_node("Minifigure"):
		character_node = get_node("Minifigure")
		print("character_node exists")
		if new_minifigure != null:
			character_node.name = "OldMinifigure"
			character_node.queue_free()
	var instance = new_minifigure.instance()
	instance.name = "Minifigure"
	self.add_child(instance)
	character_node = instance
	minifigure = new_minifigure
