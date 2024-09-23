extends Node
class_name ExperienceManager

signal experience_updated(current_experience : float, target_experience : float)
signal level_up(new_level : int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 1


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_collected)


func increment_experience(number : float):
	current_experience = min(current_experience + number, target_experience) # Like max() it'll return whichever number is the lowest (so if experience goes above target_experience, then it'll return target experience)
	experience_updated.emit(current_experience,target_experience)
	
	if current_experience == target_experience: # Check if we've reached the level up threshold
		current_level += 1 # Gain a level
		target_experience += TARGET_EXPERIENCE_GROWTH # Increase the new experience target
		current_experience = 0 # Reset the current experience
		experience_updated.emit(current_experience, target_experience) # Emit that something has been updated
		level_up.emit(current_level)


func on_experience_collected(number : float):
	var audio_player = $AudioStreamPlayer as AudioStreamPlayer
	if audio_player.is_playing():
		audio_player.stop()
	audio_player.play()
	await audio_player.finished
	
	increment_experience(number)
