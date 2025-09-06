extends Control

@onready var level_label = $TopPanel/VBoxContainer/LevelLabel
@onready var score_label = $TopPanel/VBoxContainer/InfoContainer/ScoreLabel
@onready var lives_label = $TopPanel/VBoxContainer/InfoContainer/LivesLabel
@onready var collectibles_label = $TopPanel/VBoxContainer/CollectiblesLabel
@onready var progress_bar = $ProgressPanel/VBoxContainer/ProgressBar

var current_score = 0
var current_lives = 3
var collectibles_collected = 0
var total_collectibles = 5

func _ready():
	# Connect to GameManager signals
	if GameManager.level_changed.is_connected(_on_level_changed):
		pass
	else:
		GameManager.level_changed.connect(_on_level_changed)
	
	if GameManager.collectible_collected.is_connected(_on_collectible_collected):
		pass
	else:
		GameManager.collectible_collected.connect(_on_collectible_collected)
	
	if GameManager.player_died.is_connected(_on_player_died):
		pass
	else:
		GameManager.player_died.connect(_on_player_died)
	
	# Set initial values
	_update_display()
	
	# Animate HUD entrance
	_animate_entrance()

func _animate_entrance():
	# Slide in from top
	var top_panel = $TopPanel
	var original_pos = top_panel.position.y
	top_panel.position.y = -150
	
	var tween = create_tween()
	tween.parallel().tween_property(top_panel, "position:y", original_pos, 0.8)
	tween.tween_callback(_animate_side_panels).set_delay(0.3)

func _animate_side_panels():
	var controls_panel = $ControlsPanel
	var progress_panel = $ProgressPanel
	
	# Slide in from right
	var controls_original = controls_panel.position.x
	controls_panel.position.x = get_viewport().size.x
	
	# Slide in from bottom
	var progress_original = progress_panel.position.y
	progress_panel.position.y = get_viewport().size.y
	
	var tween = create_tween()
	tween.parallel().tween_property(controls_panel, "position:x", controls_original, 0.6)
	tween.parallel().tween_property(progress_panel, "position:y", progress_original, 0.6)

func _on_level_changed(level_name: String):
	level_label.text = level_name
	_animate_level_change()

func _animate_level_change():
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color.YELLOW, 0.3)
	tween.tween_property(level_label, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(level_label, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(level_label, "modulate", Color.WHITE, 0.3)

func _on_collectible_collected(value: int):
	collectibles_collected += 1
	current_score += value
	_update_display()
	_animate_score_gain()

func _animate_score_gain():
	var tween = create_tween()
	tween.tween_property(score_label, "modulate", Color.GREEN, 0.2)
	tween.tween_property(score_label, "scale", Vector2(1.3, 1.3), 0.2)
	tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_property(score_label, "modulate", Color.WHITE, 0.2)

func _on_player_died():
	current_lives = GameManager.get_player_lives()
	_update_display()
	_animate_life_lost()

func _animate_life_lost():
	var tween = create_tween()
	tween.tween_property(lives_label, "modulate", Color.RED, 0.3)
	tween.tween_property(lives_label, "scale", Vector2(1.4, 1.4), 0.3)
	tween.tween_property(lives_label, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(lives_label, "modulate", Color.WHITE, 0.3)

func _update_display():
	current_score = GameManager.get_player_score()
	current_lives = GameManager.get_player_lives()
	
	score_label.text = "Score: " + str(current_score)
	lives_label.text = "Lives: " + str(current_lives)
	collectibles_label.text = "Collectibles: " + str(collectibles_collected) + "/" + str(total_collectibles)
	
	# Update progress bar
	var progress = float(collectibles_collected) / float(total_collectibles) * 100.0
	progress_bar.value = progress
	
	# Change progress bar color based on completion
	var fill_style = progress_bar.get_theme_stylebox("fill")
	if fill_style is StyleBoxFlat:
		if progress >= 100:
			fill_style.bg_color = Color.GOLD
		elif progress >= 75:
			fill_style.bg_color = Color.GREEN
		elif progress >= 50:
			fill_style.bg_color = Color.YELLOW
		else:
			fill_style.bg_color = Color(0.2, 0.8, 1, 1)

func show_completion_message():
	# Create temporary completion message
	var completion_label = Label.new()
	completion_label.text = "LEVEL COMPLETE!"
	completion_label.add_theme_font_size_override("font_size", 48)
	completion_label.add_theme_color_override("font_color", Color.GOLD)
	completion_label.position = Vector2(get_viewport().size.x / 2 - 200, get_viewport().size.y / 2 - 50)
	add_child(completion_label)
	
	# Animate and remove
	var tween = create_tween()
	tween.tween_property(completion_label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(completion_label.queue_free)
