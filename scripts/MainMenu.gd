extends Control
class_name MainMenu

@onready var play_button = $VBoxContainer/PlayButton
@onready var level_select_button = $VBoxContainer/LevelSelectButton
@onready var high_scores_button = $VBoxContainer/HighScoresButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var title_label = $TitleLabel
@onready var subtitle_label = $SubtitleLabel

# Background effects
var star_particles: GPUParticles3D
var nebula_particles: GPUParticles3D
var rotation_speed: float = 0.1

func _ready():
	setup_connections()
	create_background_effects()
	animate_title_entrance()
	
	# Start menu music
	AudioManager.play_music("menu", true)
	
	print("STELLAR ODYSSEY - Main Menu Initialized")
	print("15 Levels Available - Including AI-Generated Fractal Levels")

func setup_connections():
	play_button.pressed.connect(_on_play_pressed)
	level_select_button.pressed.connect(_on_level_select_pressed)
	high_scores_button.pressed.connect(_on_high_scores_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func create_background_effects():
	# Create star field particles
	star_particles = GPUParticles3D.new()
	star_particles.amount = 200
	star_particles.emitting = true
	star_particles.lifetime = 10.0
	add_child(star_particles)
	
	# Create nebula particles
	nebula_particles = GPUParticles3D.new()
	nebula_particles.amount = 50
	nebula_particles.emitting = true
	nebula_particles.lifetime = 15.0
	add_child(nebula_particles)

func animate_title_entrance():
	# Title slides in from top
	title_label.position.y = -200
	subtitle_label.modulate.a = 0.0
	
	var tween = create_tween()
	tween.parallel().tween_property(title_label, "position:y", 50, 1.0)
	tween.parallel().tween_property(subtitle_label, "modulate:a", 1.0, 1.5).set_delay(0.5)
	
	# Animate buttons in sequence
	var buttons = [play_button, level_select_button, high_scores_button, settings_button, quit_button]
	for i in range(buttons.size()):
		var button = buttons[i]
		button.modulate.a = 0.0
		button.scale = Vector2.ZERO
		tween.parallel().tween_property(button, "modulate:a", 1.0, 0.3).set_delay(1.0 + i * 0.1)
		tween.parallel().tween_property(button, "scale", Vector2.ONE, 0.3).set_delay(1.0 + i * 0.1)

func _process(delta):
	# Rotate background effects
	if star_particles:
		star_particles.rotation.y += rotation_speed * delta
	if nebula_particles:
		nebula_particles.rotation.x += rotation_speed * 0.5 * delta

func _on_play_pressed():
	print("Starting Level 1 - Asteroid Fields")
	transition_to_level(1)

func _on_level_select_pressed():
	print("Opening Level Selection")
	transition_to_scene("res://scenes/LevelSelector.tscn")

func _on_high_scores_pressed():
	print("Opening High Scores")
	show_high_scores_popup()

func _on_settings_pressed():
	print("Opening Settings")
	show_settings_popup()

func _on_quit_pressed():
	print("Quitting game")
	get_tree().quit()

func transition_to_level(level_number: int):
	# Fade out effect
	var fade_overlay = ColorRect.new()
	fade_overlay.color = Color.BLACK
	fade_overlay.color.a = 0.0
	fade_overlay.size = get_viewport().size
	add_child(fade_overlay)
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	await tween.finished
	
	# Load the level
	GameManager.load_level(level_number, false)

func transition_to_scene(scene_path: String):
	var fade_overlay = ColorRect.new()
	fade_overlay.color = Color.BLACK
	fade_overlay.color.a = 0.0
	fade_overlay.size = get_viewport().size
	add_child(fade_overlay)
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.3)
	await tween.finished
	
	get_tree().change_scene_to_file(scene_path)

func show_high_scores_popup():
	# Create high scores popup
	var popup = AcceptDialog.new()
	popup.title = "HIGH SCORES - GALACTIC LEADERBOARD"
	popup.size = Vector2(600, 400)
	
	var vbox = VBoxContainer.new()
	popup.add_child(vbox)
	
	var title_label = Label.new()
	title_label.text = "TOP SPACE PILOTS"
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Get high scores from ScoreManager
	var high_scores = ScoreManager.get_high_scores()
	
	if high_scores.size() == 0:
		var no_scores = Label.new()
		no_scores.text = "No scores yet - be the first galactic champion!"
		no_scores.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(no_scores)
	else:
		for i in range(min(10, high_scores.size())):
			var entry = high_scores[i]
			var score_label = Label.new()
			score_label.text = str(i + 1) + ". " + entry["name"] + " - " + format_score(entry["score"]) + " pts (Level " + str(entry["level"]) + ")"
			score_label.add_theme_font_size_override("font_size", 16)
			vbox.add_child(score_label)
	
	add_child(popup)
	popup.popup_centered()

func show_settings_popup():
	# Create settings popup
	var popup = AcceptDialog.new()
	popup.title = "STELLAR ODYSSEY SETTINGS"
	popup.size = Vector2(500, 300)
	
	var vbox = VBoxContainer.new()
	popup.add_child(vbox)
	
	var title_label = Label.new()
	title_label.text = "GAME SETTINGS"
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# SFX Volume
	var sfx_label = Label.new()
	sfx_label.text = "Sound Effects Volume:"
	vbox.add_child(sfx_label)
	
	var sfx_slider = HSlider.new()
	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.value = AudioManager.sfx_volume
	sfx_slider.step = 0.1
	sfx_slider.value_changed.connect(AudioManager.set_sfx_volume)
	vbox.add_child(sfx_slider)
	
	# Music Volume
	var music_label = Label.new()
	music_label.text = "Music Volume:"
	vbox.add_child(music_label)
	
	var music_slider = HSlider.new()
	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.value = AudioManager.music_volume
	music_slider.step = 0.1
	music_slider.value_changed.connect(AudioManager.set_music_volume)
	vbox.add_child(music_slider)
	
	add_child(popup)
	popup.popup_centered()

func format_score(score: int) -> String:
	var score_str = str(score)
	var formatted = ""
	var count = 0
	
	for i in range(score_str.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			formatted = "," + formatted
		formatted = score_str[i] + formatted
		count += 1
	
	return formatted
