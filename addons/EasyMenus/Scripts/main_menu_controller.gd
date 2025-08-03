extends Control
signal start_game_pressed

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: Control = $%OptionsMenu
@onready var content: Control = $%Content 

func _ready():
	print("amogus")
	GlobalStream.stream = load("res://assets/music/menu.mp3")
	GlobalStream.play()
	if OS.has_environment("web"):
		$Content/QuitButton.queue_free()
	start_game_button.grab_focus()

func quit():
	get_tree().quit()
	
func open_options():
	options_menu.show()
	content.hide()
	options_menu.on_open()
	
func close_options():
	content.show();
	start_game_button.grab_focus()
	options_menu.hide()



func _on_start_game_button_pressed():
	GlobalStream.stream = load("res://assets/music/blue_drive_remix.mp3")
	GlobalStream.play()
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
