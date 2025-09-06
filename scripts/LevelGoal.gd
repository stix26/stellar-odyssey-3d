extends Area3D

@export var next_level_number: int = 2
@export var goal_message: String = "Level Complete!"

var player_in_area = false
var rotation_speed = 2.0
var float_amplitude = 0.5
var float_speed = 3.0
var original_y: float

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Store original position for floating animation
	original_y = global_position.y
	
	# Set up collision detection for player
	collision_layer = 16  # Goals layer
	collision_mask = 2    # Player layer
	
	print("Goal initialized for level ", next_level_number, " at position ", global_position)

func _process(delta):
	# Rotate the goal sphere
	rotation.y += rotation_speed * delta
	
	# Float up and down
	var time = Time.get_time_dict_from_system()["second"] + Time.get_time_dict_from_system()["minute"] * 60.0
	var new_y = original_y + sin(time * float_speed) * float_amplitude
	global_position.y = new_y
	
	# Pulse the light intensity
	var light = get_node_or_null("OmniLight3D")
	if light:
		var base_energy = 2.0 + (next_level_number * 0.1)
		light.light_energy = base_energy + sin(time * 4.0) * 0.5

func _on_body_entered(body):
	# Check if it's the player by looking for the Player class or CharacterBody3D
	if body is CharacterBody3D or body.name == "Player" or body.has_method("show_pause_menu"):
		player_in_area = true
		print("GOAL REACHED! " + goal_message)
		print("Progressing to level: " + str(next_level_number))
		
		# Visual feedback
		create_completion_effect()
		
		# Add a small delay for better user experience
		await get_tree().create_timer(1.0).timeout
		
		# Progress to next level
		if next_level_number <= GameManager.max_level:
			print("Loading next level via GameManager...")
			GameManager.load_level(next_level_number)
		else:
			print("Game complete!")
			GameManager.complete_game()

func _on_body_exited(body):
	if body is CharacterBody3D or body.name == "Player" or body.has_method("show_pause_menu"):
		player_in_area = false

func create_completion_effect():
	# Create explosion of particles
	var particles = get_node_or_null("../CompletionParticles")
	if particles:
		particles.emitting = true
	
	# Screen flash effect (could be implemented via HUD)
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector3(1.5, 1.5, 1.5), 0.3)
	tween.parallel().tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.3).set_delay(0.3)
	
	# Light burst
	var light = get_node_or_null("OmniLight3D")
	if light:
		var original_energy = light.light_energy
		tween.parallel().tween_property(light, "light_energy", original_energy * 3.0, 0.2)
		tween.parallel().tween_property(light, "light_energy", original_energy, 0.4).set_delay(0.2)
