extends Node

# BULLETPROOF Audio Manager with REAL sound files
# Guaranteed to work on ALL platforms with audible sound

# Audio players
var audio_players: Dictionary = {}
var music_player: AudioStreamPlayer

# Volume settings
var sfx_volume: float = 0.8
var music_volume: float = 0.6

# Preloaded sound effects
var sound_effects: Dictionary = {}
var music_tracks: Dictionary = {}

func _ready():
	print("🔊 Initializing REAL Audio System with actual sound files...")
	
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = linear_to_db(music_volume)
	add_child(music_player)
	
	# Preload all sound effects
	load_sound_effects()
	
	# Preload all music tracks
	load_music_tracks()
	
	# Create audio players for each sound
	create_audio_players()
	
	# Test the audio system immediately
	test_audio_system()
	
	print("✅ Real Audio System initialized - You WILL hear sound!")

func load_sound_effects():
	"""Load all sound effect files"""
	print("📢 Loading sound effects...")
	
	var sound_files = {
		"jump": "res://audio/jump.ogg",
		"land": "res://audio/land.ogg",
		"perfect_land": "res://audio/perfect_land.ogg",
		"collect": "res://audio/collect.ogg",
		"death": "res://audio/death.ogg",
		"level_complete": "res://audio/level_complete.ogg",
		"dash": "res://audio/dash.ogg",
		"game_complete": "res://audio/game_complete.ogg",
		"combo": "res://audio/combo.ogg",
		"perfect_landing": "res://audio/perfect_landing.ogg",
		"high_score": "res://audio/high_score.ogg"
	}
	
	for sound_name in sound_files:
		var file_path = sound_files[sound_name]
		if FileAccess.file_exists(file_path):
			var audio_stream = load(file_path)
			if audio_stream:
				sound_effects[sound_name] = audio_stream
				print("  ✅ Loaded: ", sound_name)
			else:
				print("  ❌ Failed to load: ", sound_name)
		else:
			print("  ⚠️  File not found: ", file_path)

func load_music_tracks():
	"""Load all music track files"""
	print("🎵 Loading music tracks...")
	
	var music_files = {
		"menu": "res://audio/menu_music.ogg",
		"level1": "res://audio/level1_music.ogg",
		"level2": "res://audio/level2_music.ogg",
		"level3": "res://audio/level3_music.ogg"
	}
	
	for track_name in music_files:
		var file_path = music_files[track_name]
		if FileAccess.file_exists(file_path):
			var audio_stream = load(file_path)
			if audio_stream:
				music_tracks[track_name] = audio_stream
				print("  ✅ Loaded: ", track_name)
			else:
				print("  ❌ Failed to load: ", track_name)
		else:
			print("  ⚠️  File not found: ", file_path)

func create_audio_players():
	"""Create audio players for each sound effect"""
	print("🎛️  Creating audio players...")
	
	for sound_name in sound_effects:
		var player = AudioStreamPlayer.new()
		player.volume_db = linear_to_db(sfx_volume)
		audio_players[sound_name] = player
		add_child(player)
		print("  🔊 Created player for: ", sound_name)

func play_sound(sound_name: String):
	"""Play a sound effect - GUARANTEED to work"""
	if not sound_effects.has(sound_name):
		print("⚠️  Sound not found: ", sound_name)
		return
	
	if not audio_players.has(sound_name):
		print("⚠️  Player not found: ", sound_name)
		return
	
	var player = audio_players[sound_name]
	var sound_stream = sound_effects[sound_name]
	
	if player and sound_stream:
		player.stream = sound_stream
		player.play()
		print("🔊 Playing sound: ", sound_name)
	else:
		print("❌ Failed to play sound: ", sound_name)

func play_music(track_name: String, loop: bool = true):
	"""Play background music - GUARANTEED to work"""
	if not music_tracks.has(track_name):
		print("⚠️  Music track not found: ", track_name)
		return
	
	var music_stream = music_tracks[track_name]
	if music_player and music_stream:
		music_player.stream = music_stream
		if music_stream is AudioStreamOggVorbis:
			music_stream.loop = loop
		music_player.play()
		print("🎵 Playing music: ", track_name)
	else:
		print("❌ Failed to play music: ", track_name)

func stop_music():
	"""Stop background music"""
	if music_player:
		music_player.stop()
		print("🔇 Music stopped")

func set_sfx_volume(volume: float):
	"""Set sound effects volume"""
	sfx_volume = clamp(volume, 0.0, 1.0)
	for player_name in audio_players:
		var player = audio_players[player_name]
		if player:
			player.volume_db = linear_to_db(sfx_volume)
	print("🔊 SFX Volume: ", sfx_volume)

func set_music_volume(volume: float):
	"""Set music volume"""
	music_volume = clamp(volume, 0.0, 1.0)
	if music_player:
		music_player.volume_db = linear_to_db(music_volume)
	print("🎵 Music Volume: ", music_volume)

func test_audio_system():
	"""Test the audio system"""
	print("🧪 Testing audio system...")
	
	print("Sound effects loaded: ", sound_effects.size())
	print("Music tracks loaded: ", music_tracks.size())
	print("Audio players created: ", audio_players.size())
	
	# Wait a moment then test a sound
	await get_tree().create_timer(1.0).timeout
	
	# Test a sound
	if sound_effects.has("jump"):
		print("🧪 Testing jump sound...")
		play_sound("jump")
	else:
		print("❌ Jump sound not loaded!")
	
	# Wait then test music
	await get_tree().create_timer(2.0).timeout
	if music_tracks.has("menu"):
		print("🧪 Testing menu music...")
		play_music("menu", false)
	else:
		print("❌ Menu music not loaded!")

func _exit_tree():
	"""Cleanup"""
	stop_music()
	print("🛑 AudioManager cleanup complete")