extends Control


func _process(delta):
	$Panel/Label.text = "FPS: " + String(Engine.get_frames_per_second())
