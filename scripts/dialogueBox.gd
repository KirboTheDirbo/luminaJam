extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const maxWidth = 256

var text = ""
var letterIndex = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

func display_text(text_to_display:String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, maxWidth)
	
	if size.x > maxWidth:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
		global_position.x -= size.x/2
		global_position.y -= size.y + 24
		label.text = ""
		
		_display_letter()

func _display_letter():
	label.text += text[letterIndex]
	
	letterIndex += 1
	
	if letterIndex >= text.length():
		finished_displaying.emit()
		return
	
	match text[letterIndex]:
		"!",".",",","?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
		

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
