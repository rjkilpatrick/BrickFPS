"""
Basic chatbox.

TODO:
	Add networking support
"""

extends Control

onready var container = $VBoxContainer/SendContainer
onready var chat_log = $VBoxContainer/MessageLog

onready var input_field = $VBoxContainer/SendContainer/Message

export(String) onready var player_name = "Player"
onready var player_label = $VBoxContainer/SendContainer/PlayerLabel

func _ready():
	container.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		leave_chatbox()

func add_message(_player_name: String, text: String):
	chat_log.bbcode_text += "\n" + _player_name + ": " + text

func enter_chatbox():
	container.visible = true
	input_field.grab_focus()
	
	player_label.text = "[" + player_name + "]"

func leave_chatbox():
	container.visible = false
	input_field.release_focus()

func _on_Message_text_entered(new_text):
		#TODO: Send messsage
	#temp
	add_message(player_name, new_text)
		
	input_field.text = ""
	leave_chatbox()
