extends Node

@onready var text_box_sceme = preload("res://scenes/other/dialogueBox.tscn")

var dialogue_lines: Array[String] = []
var current_line_index = 0

var textBox
var text_box_position:Vector2

var dialogueActive = false
var canAdvance = false

func start_Dialogue(position,lines):
	if dialogueActive:
		return
	
	dialogue_lines = lines
	text_box_position = position
	
	_show_dialogue_box()
	
	dialogueActive = true

func _show_dialogue_box():
	textBox = text_box_sceme.instantiate()
	textBox.finished_displaying.connect(_on_finished_displaying)
	get_tree().root.add_child(textBox)
	textBox.global_position = text_box_position
	textBox.display_text(dialogue_lines[current_line_index])

func _on_finished_displaying():
	canAdvance = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("dialogue_action") &&
		dialogueActive &&
		canAdvance
	):
		textBox.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			dialogueActive = false
			current_line_index = 0
			return
		_show_dialogue_box()
