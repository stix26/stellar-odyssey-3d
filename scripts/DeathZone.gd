extends Area3D
class_name DeathZone

signal player_died

# Death effects will be created procedurally

func _ready():
	# Set up death zone collision
	collision_layer = 32  # Death zone layer
	collision_mask = 2    # Player layer
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	
	# Create visual indicator
	create_death_zone_visual()

func _on_body_entered(body):
	if body.name == "Player":
		print("PLAYER DEATH DETECTED!")
		trigger_death_sequence(body)

func trigger_death_sequence(player):
	# Disable player controls
	player.set_physics_process(false)
	player.set_process_input(false)
	
	# Create death effects
	create_death_effects(player.global_position)
	
	# Camera shake
	if player.has_method("camera_shake"):
		player.camera_shake(2.0, 1.0)
	
	# Sound effect
	AudioManager.play_sound("death")
	
	# Emit death signal
	player_died.emit()
	
	# Wait for effects then respawn
	await get_tree().create_timer(2.0).timeout
	GameManager.player_death()

func create_death_effects(position: Vector3):
	# Create procedural explosion particles
	var explosion = GPUParticles3D.new()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = position
	explosion.amount = 200
	explosion.emitting = true
	
	# Screen flash effect
	var flash_tween = create_tween()
	flash_tween.tween_method(_screen_flash, 0.0, 1.0, 0.3)
	flash_tween.tween_method(_screen_flash, 1.0, 0.0, 0.7)

func _screen_flash(intensity: float):
	# This would control screen flash overlay
	pass

func create_death_zone_visual():
	# Create a subtle red fog effect to indicate danger
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(1000, 5, 1000)
	mesh_instance.mesh = box_mesh
	
	# Create danger material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0.2, 0.2, 0.1)
	material.emission_enabled = true
	material.emission = Color(1, 0, 0, 1)
	material.emission_energy = 0.3
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_instance.material_override = material
	
	add_child(mesh_instance)
	
	# Create collision shape
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(1000, 5, 1000)
	collision_shape.shape = box_shape
	add_child(collision_shape)
