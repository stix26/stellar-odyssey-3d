extends Node

signal score_changed(new_score: int)
signal perfect_landing(bonus_points: int)
signal combo_achieved(combo_count: int, multiplier: float)

# Scoring constants
const BASE_LANDING_POINTS = 100
const PERFECT_LANDING_BONUS = 500
const COMBO_MULTIPLIER = 1.5
const HEIGHT_BONUS_MULTIPLIER = 10
const SPEED_BONUS_MULTIPLIER = 5
const DASH_LANDING_BONUS = 250

# Score tracking
var total_score: int = 0
var level_score: int = 0
var landing_count: int = 0
var perfect_landing_count: int = 0
var combo_count: int = 0
var last_landing_time: float = 0.0
var combo_time_window: float = 3.0

# High scores system
var high_scores: Array[Dictionary] = []
var current_session_best: int = 0
var player_name: String = ""
var awaiting_name_entry: bool = false

# Analytics
var player_analytics = {
	"total_jumps": 0,
	"total_dashes": 0,
	"total_landings": 0,
	"perfect_landings": 0,
	"deaths": 0,
	"levels_completed": 0,
	"time_played": 0.0
}

func _ready():
	load_high_scores()
	create_fake_high_scores()
	print("ScoreManager initialized - Nuclear scoring system active")

func calculate_landing_score(landing_data: Dictionary) -> int:
	var base_score = BASE_LANDING_POINTS
	var bonus_score = 0
	var multiplier = 1.0
	
	# Height bonus - reward high jumps
	var height_bonus = int(landing_data.get("fall_height", 0) * HEIGHT_BONUS_MULTIPLIER)
	bonus_score += height_bonus
	
	# Speed bonus - reward fast landings
	var speed_bonus = int(landing_data.get("landing_speed", 0) * SPEED_BONUS_MULTIPLIER)
	bonus_score += speed_bonus
	
	# Perfect landing detection
	if is_perfect_landing(landing_data):
		bonus_score += PERFECT_LANDING_BONUS
		perfect_landing_count += 1
		perfect_landing.emit(PERFECT_LANDING_BONUS)
		print("PERFECT LANDING! +" + str(PERFECT_LANDING_BONUS) + " bonus points!")
	
	# Dash landing bonus
	if landing_data.get("was_dashing", false):
		bonus_score += DASH_LANDING_BONUS
		print("DASH LANDING! +" + str(DASH_LANDING_BONUS) + " bonus points!")
	
	# Combo system
	var current_time = Time.get_time_dict_from_system()["second"]
	if current_time - last_landing_time < combo_time_window:
		combo_count += 1
		multiplier = pow(COMBO_MULTIPLIER, combo_count)
		combo_achieved.emit(combo_count, multiplier)
		print("COMBO x" + str(combo_count) + "! Multiplier: " + str(multiplier))
	else:
		combo_count = 0
	
	last_landing_time = current_time
	
	var final_score = int((base_score + bonus_score) * multiplier)
	add_score(final_score)
	
	# Update analytics
	player_analytics["total_landings"] += 1
	if is_perfect_landing(landing_data):
		player_analytics["perfect_landings"] += 1
	
	return final_score

func is_perfect_landing(landing_data: Dictionary) -> bool:
	# AI-determined perfect landing criteria
	var velocity = landing_data.get("landing_velocity", Vector3.ZERO)
	var impact_angle = landing_data.get("impact_angle", 0.0)
	var platform_center_distance = landing_data.get("platform_center_distance", 999.0)
	
	# Perfect landing requirements (AI-tuned)
	return (
		velocity.length() < 8.0 and  # Not too fast
		abs(impact_angle) < 15.0 and  # Nearly vertical landing
		platform_center_distance < 2.0  # Near platform center
	)

func add_score(points: int):
	total_score += points
	level_score += points
	score_changed.emit(total_score)
	
	# Check for new session best
	if total_score > current_session_best:
		current_session_best = total_score
		print("NEW SESSION BEST: " + str(total_score))

func level_completed_bonus(level_number: int, completion_time: float):
	# AI-calculated level completion bonus
	var time_bonus = max(0, int(300 - completion_time * 10))  # Time bonus
	var level_multiplier = level_number * 0.1 + 1.0  # Harder levels worth more
	var completion_bonus = int((1000 + time_bonus) * level_multiplier)
	
	add_score(completion_bonus)
	player_analytics["levels_completed"] += 1
	
	print("LEVEL " + str(level_number) + " COMPLETED!")
	print("Time Bonus: " + str(time_bonus))
	print("Completion Bonus: " + str(completion_bonus))

func player_died():
	player_analytics["deaths"] += 1
	# Small score penalty for death
	total_score = max(0, total_score - 50)
	combo_count = 0  # Reset combo on death
	score_changed.emit(total_score)

func save_high_score():
	var score_entry = {
		"score": total_score,
		"timestamp": Time.get_datetime_string_from_system(),
		"levels_completed": player_analytics["levels_completed"],
		"perfect_landings": player_analytics["perfect_landings"],
		"total_landings": player_analytics["total_landings"],
		"accuracy": float(player_analytics["perfect_landings"]) / max(1, player_analytics["total_landings"])
	}
	
	high_scores.append(score_entry)
	high_scores.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# Keep only top 10
	if high_scores.size() > 10:
		high_scores = high_scores.slice(0, 10)
	
	save_high_scores()
	print("HIGH SCORE SAVED: " + str(total_score))

func get_high_scores() -> Array[Dictionary]:
	# Return sorted high scores (highest first)
	var sorted_scores = high_scores.duplicate()
	sorted_scores.sort_custom(func(a, b): return a.score > b.score)
	return sorted_scores

func get_current_rank() -> int:
	for i in range(high_scores.size()):
		if total_score > high_scores[i]["score"]:
			return i + 1
	return high_scores.size() + 1

func save_high_scores():
	var file = FileAccess.open("user://high_scores.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(high_scores))
		file.close()

func load_high_scores():
	if FileAccess.file_exists("user://high_scores.json"):
		var file = FileAccess.open("user://high_scores.json", FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				high_scores = json.data
			else:
				print("Error parsing high scores JSON")

func create_fake_high_scores():
	# Only add fake scores if we have no existing high scores
	if high_scores.size() == 0:
		high_scores = [
			{"name": "NOVA_MASTER", "score": 15420, "level": 15},
			{"name": "STAR_JUMPER", "score": 12850, "level": 12},
			{"name": "COSMIC_ACE", "score": 11200, "level": 10},
			{"name": "GALAXY_HERO", "score": 9750, "level": 9},
			{"name": "VOID_WALKER", "score": 8300, "level": 8},
			{"name": "METEOR_DASH", "score": 7100, "level": 7},
			{"name": "NEBULA_PRO", "score": 6200, "level": 6},
			{"name": "ORBIT_KING", "score": 5400, "level": 5},
			{"name": "PLASMA_LEAP", "score": 4650, "level": 4},
			{"name": "ASTRO_NINJA", "score": 3900, "level": 3}
		]
		save_high_scores()
		print("Added fake high scores for leaderboard")

func reset_level_score():
	level_score = 0

func is_high_score(score: int) -> bool:
	# Check if score qualifies for high score list (top 10)
	if high_scores.size() < 10:
		return true
	
	# Sort high scores by score (descending)
	var sorted_scores = high_scores.duplicate()
	sorted_scores.sort_custom(func(a, b): return a.score > b.score)
	
	# Check if score is higher than the lowest high score
	return score > sorted_scores[-1].score

func submit_high_score(name: String, score: int, level: int):
	var new_entry = {"name": name, "score": score, "level": level}
	high_scores.append(new_entry)
	
	# Sort by score (descending)
	high_scores.sort_custom(func(a, b): return a.score > b.score)
	
	# Keep only top 10
	if high_scores.size() > 10:
		high_scores = high_scores.slice(0, 10)
	
	save_high_scores()
	print("New high score submitted: ", name, " - ", score, " points!")

func get_high_score_position(score: int) -> int:
	# Return the position (1-10) where this score would rank
	var sorted_scores = high_scores.duplicate()
	sorted_scores.sort_custom(func(a, b): return a.score > b.score)
	
	for i in range(sorted_scores.size()):
		if score > sorted_scores[i].score:
			return i + 1
	
	return sorted_scores.size() + 1


func get_score_breakdown() -> Dictionary:
	return {
		"total_score": total_score,
		"level_score": level_score,
		"landing_count": landing_count,
		"perfect_landings": perfect_landing_count,
		"combo_count": combo_count,
		"current_rank": get_current_rank()
	}
