extends Control
class_name NuclearHUD

# UI Elements
@onready var level_label = $TopPanel/VBoxContainer/LevelLabel
@onready var score_label = $TopPanel/VBoxContainer/InfoContainer/ScoreLabel
@onready var lives_label = $TopPanel/VBoxContainer/InfoContainer/LivesLabel
@onready var combo_label = $TopPanel/VBoxContainer/ComboLabel
@onready var high_score_panel = $HighScorePanel
@onready var high_score_list = $HighScorePanel/VBoxContainer/HighScoreList
@onready var analytics_panel = $AnalyticsPanel
@onready var landing_feedback = $LandingFeedback
@onready var progress_bar = $ProgressPanel/VBoxContainer/ProgressBar
@onready var level_progress_label = $ProgressPanel/VBoxContainer/LevelProgressLabel

# Animation and effects
var score_animation_tween: Tween
var combo_animation_tween: Tween
var particle_system: GPUParticles3D

# AI-driven dynamic UI
var ui_intelligence_level: float = 1.0
var adaptive_opacity: float = 0.8
var neural_color_shift: float = 0.0

func _ready():
	# Connect to all manager signals
	connect_signals()
	
	# Initialize nuclear-level UI
	setup_nuclear_interface()
	
	# Start AI-driven UI updates
	start_intelligent_ui_system()
	
	print("NUCLEAR HUD INITIALIZED - AI INTERFACE ACTIVE")

func connect_signals():
	# ScoreManager connections
	if ScoreManager.score_changed.is_connected(_on_score_changed):
		pass
	else:
		ScoreManager.score_changed.connect(_on_score_changed)
	
	if ScoreManager.perfect_landing.is_connected(_on_perfect_landing):
		pass
	else:
		ScoreManager.perfect_landing.connect(_on_perfect_landing)
	
	if ScoreManager.combo_achieved.is_connected(_on_combo_achieved):
		pass
	else:
		ScoreManager.combo_achieved.connect(_on_combo_achieved)
	
	# GameManager connections
	if GameManager.level_changed.is_connected(_on_level_changed):
		pass
	else:
		GameManager.level_changed.connect(_on_level_changed)

func setup_nuclear_interface():
	# Create dynamic particle background
	create_ui_particle_system()
	
	# Initialize all displays
	update_all_displays()
	
	# Setup high score panel
	setup_high_score_display()
	
	# Create analytics display
	setup_analytics_display()
	
	# Animate entrance with AI-calculated timing
	animate_nuclear_entrance()

func start_intelligent_ui_system():
	# AI-driven UI updates every frame
	var ui_timer = Timer.new()
	ui_timer.wait_time = 0.016  # 60 FPS updates
	ui_timer.timeout.connect(_ai_ui_update)
	add_child(ui_timer)
	ui_timer.start()

func _ai_ui_update():
	# Neural network-inspired UI adaptations
	neural_color_shift += 0.01
	if neural_color_shift > PI * 2:
		neural_color_shift = 0.0
	
	# Adaptive UI opacity based on game state
	var player_speed = get_player_velocity_magnitude()
	adaptive_opacity = lerp(0.6, 1.0, clamp(player_speed / 20.0, 0.0, 1.0))
	
	# Apply AI-calculated visual enhancements
	apply_neural_visual_effects()
	
	# Update progress indicators
	update_intelligent_progress()

func get_player_velocity_magnitude() -> float:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("get_velocity"):
		return player.velocity.length()
	return 0.0

func apply_neural_visual_effects():
	# AI-generated color harmonics
	var hue_shift = sin(neural_color_shift) * 0.1
	var saturation_boost = cos(neural_color_shift * 2) * 0.2 + 1.0
	
	# Apply to UI elements
	modulate = Color(
		1.0 + hue_shift,
		1.0 + hue_shift * 0.5,
		1.0 - hue_shift * 0.3,
		adaptive_opacity
	)

func _on_score_changed(new_score: int):
	score_label.text = "SCORE: " + format_number_with_commas(new_score)
	animate_score_change()
	
	# Check for high score
	if new_score > ScoreManager.current_session_best:
		trigger_high_score_celebration()

func _on_perfect_landing(bonus_points: int):
	show_landing_feedback("PERFECT LANDING!", Color.GOLD, bonus_points)
	create_perfect_landing_effects()

func _on_combo_achieved(combo_count: int, multiplier: float):
	combo_label.text = "COMBO x" + str(combo_count) + " (x" + str("%.1f" % multiplier) + ")"
	combo_label.visible = true
	animate_combo_display()

func _on_level_changed(level_name: String):
	level_label.text = level_name + " (" + str(GameManager.current_level) + "/15)"
	animate_nuclear_level_change()

func show_landing_feedback(text: String, color: Color, points: int):
	landing_feedback.text = text + "\n+" + str(points) + " POINTS"
	landing_feedback.modulate = color
	landing_feedback.visible = true
	
	# Animate feedback
	var tween = create_tween()
	tween.parallel().tween_property(landing_feedback, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(landing_feedback, "modulate:a", 1.0, 0.2)
	tween.tween_property(landing_feedback, "scale", Vector2(1.0, 1.0), 0.3).set_delay(0.5)
	tween.parallel().tween_property(landing_feedback, "modulate:a", 0.0, 0.3).set_delay(0.5)
	tween.tween_callback(func(): landing_feedback.visible = false)

func animate_score_change():
	if score_animation_tween:
		score_animation_tween.kill()
	
	score_animation_tween = create_tween()
	score_animation_tween.tween_property(score_label, "scale", Vector2(1.3, 1.3), 0.1)
	score_animation_tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.2)

func animate_combo_display():
	if combo_animation_tween:
		combo_animation_tween.kill()
	
	combo_animation_tween = create_tween()
	combo_animation_tween.tween_property(combo_label, "rotation", PI * 0.1, 0.1)
	combo_animation_tween.tween_property(combo_label, "rotation", 0.0, 0.1)
	combo_animation_tween.tween_property(combo_label, "modulate:a", 0.0, 2.0).set_delay(1.0)
	combo_animation_tween.tween_callback(func(): combo_label.visible = false)

func trigger_high_score_celebration():
	print("NEW HIGH SCORE ACHIEVED!")
	AudioManager.play_sound("high_score")
	
	# Screen flash effect
	var flash_overlay = ColorRect.new()
	flash_overlay.color = Color(1, 1, 0, 0.3)
	flash_overlay.size = get_viewport().size
	add_child(flash_overlay)
	
	var flash_tween = create_tween()
	flash_tween.tween_property(flash_overlay, "modulate:a", 0.0, 1.0)
	flash_tween.tween_callback(flash_overlay.queue_free)

func setup_high_score_display():
	var high_scores = ScoreManager.get_high_scores()
	
	# Clear existing entries
	for child in high_score_list.get_children():
		child.queue_free()
	
	# Add high score entries
	for i in range(min(5, high_scores.size())):
		var entry = high_scores[i]
		var label = Label.new()
		label.text = str(i + 1) + ". " + format_number_with_commas(entry["score"]) + " (" + str(entry["levels_completed"]) + " levels)"
		label.add_theme_font_size_override("font_size", 16)
		high_score_list.add_child(label)

func setup_analytics_display():
	# AI-powered analytics display
	var analytics = ScoreManager.player_analytics
	
	analytics_panel.get_node("VBoxContainer/AccuracyLabel").text = "Accuracy: " + str("%.1f" % (analytics.get("perfect_landings", 0) / max(1, analytics.get("total_landings", 1)) * 100)) + "%"
	analytics_panel.get_node("VBoxContainer/EfficiencyLabel").text = "Efficiency: " + calculate_ai_efficiency_rating()

func calculate_ai_efficiency_rating() -> String:
	var analytics = ScoreManager.player_analytics
	var deaths = analytics.get("deaths", 0)
	var completions = analytics.get("levels_completed", 0)
	var efficiency = float(completions) / max(1, deaths + completions)
	
	if efficiency > 0.9:
		return "GODLIKE"
	elif efficiency > 0.7:
		return "LEGENDARY"
	elif efficiency > 0.5:
		return "SKILLED"
	else:
		return "LEARNING"

func update_intelligent_progress():
	var current_level = GameManager.current_level
	var progress = float(current_level) / float(GameManager.max_level) * 100.0
	
	progress_bar.value = progress
	level_progress_label.text = "Progress: " + str(current_level) + "/15 (" + str("%.1f" % progress) + "%)"

func format_number_with_commas(number: int) -> String:
	var num_str = str(number)
	var formatted = ""
	var count = 0
	
	for i in range(num_str.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			formatted = "," + formatted
		formatted = num_str[i] + formatted
		count += 1
	
	return formatted

func create_ui_particle_system():
	particle_system = GPUParticles3D.new()
	particle_system.amount = 50
	particle_system.emitting = true
	add_child(particle_system)

func create_perfect_landing_effects():
	# Nuclear-level perfect landing celebration
	var celebration_particles = GPUParticles3D.new()
	add_child(celebration_particles)
	celebration_particles.amount = 100
	celebration_particles.emitting = true
	
	# Remove after animation
	get_tree().create_timer(3.0).timeout.connect(celebration_particles.queue_free)

func animate_nuclear_level_change():
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color.CYAN, 0.3)
	tween.tween_property(level_label, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(level_label, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(level_label, "modulate", Color.WHITE, 0.3)

func animate_nuclear_entrance():
	# AI-calculated entrance animation
	var entrance_delay = 0.1
	var panels = [level_label, score_label, combo_label, progress_bar]
	
	for panel in panels:
		panel.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.5).set_delay(entrance_delay)
		entrance_delay += 0.1

func update_all_displays():
	_on_score_changed(ScoreManager.total_score)
	_on_level_changed(GameManager.get_level_name())
	update_intelligent_progress()
	setup_high_score_display()
	setup_analytics_display()
