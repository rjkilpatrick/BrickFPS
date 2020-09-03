extends Control


func _process(_delta):
	$Panel/Label.text = "FPS: " + String(Engine.get_frames_per_second())
