extends Control
class_name LevelSelector

signal level_selected(level_number: int)

@onready var level_grid = $MainContainer/LeftPanel/VBox/ScrollContainer/LevelGrid
@onready var preview_panel = $MainContainer/PreviewPanel
@onready var preview_label = $MainContainer/PreviewPanel/VBox/LevelNameLabel
@onready var preview_description = $MainContainer/PreviewPanel/VBox/DescriptionLabel
@onready var preview_stats = $MainContainer/PreviewPanel/VBox/StatsLabel
@onready var play_button = $MainContainer/PreviewPanel/VBox/PlayButton
@onready var back_button = $BackButton

var selected_level: int = 1
var level_buttons: Array[Button] = []

# Level data for preview
var level_data = {
	1: {
		"name": "Tutorial - Easy Start",
		"description": "Super easy tutorial level with huge platforms. Impossible to fail! Learn basic movement.",
		"difficulty": "★☆☆☆☆",
		"platforms": 4,
		"type": "Tutorial"
	},
	2: {
		"name": "Nebula Drift", 
		"description": "Navigate through colorful cosmic clouds with increased height challenges.",
		"difficulty": "★★☆☆☆",
		"platforms": 8,
		"type": "Standard"
	},
	3: {
		"name": "Solar Winds",
		"description": "AI-GENERATED: Fractal spiral mathematics create impossible geometric challenges.",
		"difficulty": "★★★☆☆", 
		"platforms": 48,
		"type": "AI Fractal"
	},
	4: {
		"name": "Meteor Shower",
		"description": "Dodge through a field of cosmic projectiles on shrinking platforms.",
		"difficulty": "★★☆☆☆",
		"platforms": 12,
		"type": "Standard"
	},
	5: {
		"name": "Binary Stars",
		"description": "Twin star systems create complex orbital platform patterns.",
		"difficulty": "★★★☆☆",
		"platforms": 15,
		"type": "Standard"
	},
	6: {
		"name": "Cosmic Rings",
		"description": "Navigate Saturn-like ring systems with circular challenges.",
		"difficulty": "★★★☆☆",
		"platforms": 18,
		"type": "Standard"
	},
	7: {
		"name": "Supernova Echo",
		"description": "AI-GENERATED: Mandelbrot Set mathematics create fractal platform arrangements.",
		"difficulty": "★★★★☆",
		"platforms": 121,
		"type": "AI Mandelbrot"
	},
	8: {
		"name": "Dark Matter",
		"description": "Invisible forces affect gravity in this mysterious region of space.",
		"difficulty": "★★★☆☆",
		"platforms": 20,
		"type": "Standard"
	},
	9: {
		"name": "Pulsar Maze",
		"description": "Rapidly pulsing neutron stars create timing-based challenges.",
		"difficulty": "★★★★☆",
		"platforms": 25,
		"type": "Standard"
	},
	10: {
		"name": "Wormhole Gate",
		"description": "Space-time distortions create portal-like spiral ascension paths.",
		"difficulty": "★★★★☆",
		"platforms": 28,
		"type": "Standard"
	},
	11: {
		"name": "Galactic Core",
		"description": "AI-GENERATED: Fibonacci Helix mathematics create perfect golden ratio spirals.",
		"difficulty": "★★★★★",
		"platforms": 42,
		"type": "AI Fibonacci"
	},
	12: {
		"name": "Quantum Leap",
		"description": "Quantum mechanics affect platform stability and player physics.",
		"difficulty": "★★★★☆",
		"platforms": 32,
		"type": "Standard"
	},
	13: {
		"name": "Black Hole Edge",
		"description": "Extreme gravitational forces at the event horizon of a black hole.",
		"difficulty": "★★★★★",
		"platforms": 35,
		"type": "Standard"
	},
	14: {
		"name": "Stellar Nursery",
		"description": "Navigate through the birth of new stars in cosmic dust clouds.",
		"difficulty": "★★★★★",
		"platforms": 38,
		"type": "Standard"
	},
	15: {
		"name": "Universe's End",
		"description": "The final frontier - where space and time cease to exist.",
		"difficulty": "★★★★★",
		"platforms": 45,
		"type": "Epic Final"
	}
}

func _ready():
	create_level_buttons()
	setup_connections()
	select_level(1)
	
	print("Level Selector initialized - 15 levels available")
	print("Back button node: ", back_button)
	print("Play button node: ", play_button)

func create_level_buttons():
	# Clear existing buttons
	for child in level_grid.get_children():
		child.queue_free()
	
	level_buttons.clear()
	
	# Create button for each level
	for i in range(1, 16):
		var button = create_level_button(i)
		level_grid.add_child(button)
		level_buttons.append(button)

func create_level_button(level_num: int) -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(100, 60)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.text = str(level_num)
	
	# Style the button
	var style_normal = StyleBoxFlat.new()
	var style_hover = StyleBoxFlat.new()
	var style_pressed = StyleBoxFlat.new()
	
	# Determine button color based on level type
	var base_color = get_level_color(level_num)
	
	style_normal.bg_color = base_color
	style_normal.border_color = Color.WHITE
	style_normal.border_width_left = 2
	style_normal.border_width_right = 2  
	style_normal.border_width_top = 2
	style_normal.border_width_bottom = 2
	style_normal.corner_radius_top_left = 8
	style_normal.corner_radius_top_right = 8
	style_normal.corner_radius_bottom_left = 8
	style_normal.corner_radius_bottom_right = 8
	
	style_hover.bg_color = base_color.lightened(0.3)
	style_hover.border_color = Color.YELLOW
	style_hover.border_width_left = 3
	style_hover.border_width_right = 3
	style_hover.border_width_top = 3
	style_hover.border_width_bottom = 3
	style_hover.corner_radius_top_left = 8
	style_hover.corner_radius_top_right = 8
	style_hover.corner_radius_bottom_left = 8
	style_hover.corner_radius_bottom_right = 8
	
	style_pressed.bg_color = base_color.darkened(0.2)
	style_pressed.border_color = Color.CYAN
	style_pressed.border_width_left = 3
	style_pressed.border_width_right = 3
	style_pressed.border_width_top = 3
	style_pressed.border_width_bottom = 3
	style_pressed.corner_radius_top_left = 8
	style_pressed.corner_radius_top_right = 8
	style_pressed.corner_radius_bottom_left = 8
	style_pressed.corner_radius_bottom_right = 8
	
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_font_size_override("font_size", 24)
	
	# Connect button signal with proper binding
	button.pressed.connect(_on_level_button_pressed.bind(level_num))
	
	# Add level name as tooltip
	button.tooltip_text = level_data[level_num]["name"]
	
	return button

func get_level_color(level_num: int) -> Color:
	var data = level_data[level_num]
	
	match data["type"]:
		"Tutorial":
			return Color.GREEN
		"Standard":
			return Color.BLUE
		"AI Fractal":
			return Color.PURPLE
		"AI Mandelbrot":
			return Color.MAGENTA
		"AI Fibonacci":
			return Color.ORANGE
		"Epic Final":
			return Color.RED
		_:
			return Color.GRAY

func setup_connections():
	play_button.pressed.connect(_on_play_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

func _on_level_button_pressed(level_num: int):
	print("Level button " + str(level_num) + " pressed!")
	select_level(level_num)

func select_level(level_num: int):
	selected_level = level_num
	update_preview(level_num)
	
	# Update button highlights
	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		if i + 1 == level_num:
			button.modulate = Color(1.2, 1.2, 1.2, 1.0)
		else:
			button.modulate = Color.WHITE

func update_preview(level_num: int):
	var data = level_data[level_num]
	
	preview_label.text = data["name"] + " (Level " + str(level_num) + ")"
	preview_description.text = data["description"]
	
	var stats_text = ""
	stats_text += "Difficulty: " + data["difficulty"] + "\n"
	stats_text += "Platforms: " + str(data["platforms"]) + "\n"
	stats_text += "Type: " + data["type"]
	
	preview_stats.text = stats_text
	
	# Special styling for AI levels
	if "AI" in data["type"]:
		preview_label.modulate = Color.CYAN
		preview_description.modulate = Color.YELLOW
	else:
		preview_label.modulate = Color.WHITE
		preview_description.modulate = Color.WHITE

func _on_play_button_pressed():
	print("Starting Level " + str(selected_level) + ": " + level_data[selected_level]["name"])
	
	# Fade transition effect
	var fade_overlay = ColorRect.new()
	fade_overlay.color = Color.BLACK
	fade_overlay.color.a = 0.0
	fade_overlay.size = get_viewport().size
	add_child(fade_overlay)
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	await tween.finished
	
	# Load the selected level
	GameManager.load_level(selected_level, false)

func _on_back_button_pressed():
	print("BACK BUTTON PRESSED - Returning to main menu")
	var result = get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	print("Scene change result: ", result)
