extends Control

@onready var score_label = $CenterContainer/Panel/VBoxContainer/ScoreLabel
@onready var position_label = $CenterContainer/Panel/VBoxContainer/PositionLabel
@onready var name_input = $CenterContainer/Panel/VBoxContainer/NameInput
@onready var submit_button = $CenterContainer/Panel/VBoxContainer/ButtonContainer/SubmitButton
@onready var skip_button = $CenterContainer/Panel/VBoxContainer/ButtonContainer/SkipButton

var player_score: int = 0
var player_level: int = 1

func _ready():
	# Focus on name input and select all text
	name_input.grab_focus()
	name_input.select_all()
	
	# Connect enter key to submit
	name_input.text_submitted.connect(_on_name_submitted)

func setup_high_score_entry(score: int, level: int):
	player_score = score
	player_level = level
	
	score_label.text = "Your Score: " + str(score)
	var position = ScoreManager.get_high_score_position(score)
	position_label.text = "Rank: #" + str(position)
	
	# Generate a random default name
	var space_names = ["SPACE_ACE", "STAR_PILOT", "COSMIC_HERO", "NOVA_RIDER", "GALAXY_MASTER"]
	name_input.text = space_names[randi() % space_names.size()]
	name_input.select_all()

func _on_submit_pressed():
	_submit_score()

func _on_skip_pressed():
	_return_to_menu()

func _on_name_submitted(text: String):
	_submit_score()

func _submit_score():
	var player_name = name_input.text.strip_edges()
	if player_name.length() == 0:
		player_name = "ANONYMOUS"
	
	# Convert to uppercase for consistency
	player_name = player_name.to_upper()
	
	# Submit the high score
	ScoreManager.submit_high_score(player_name, player_score, player_level)
	
	# Play a success sound
	AudioManager.play_sound("level_complete")
	
	_return_to_menu()

func _return_to_menu():
	# Return to main menu
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _input(event):
	# Allow ESC to skip
	if event.is_action_pressed("ui_cancel"):
		_return_to_menu()
