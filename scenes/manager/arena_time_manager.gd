extends Node

signal arena_difficulty_increase(arena_difficulty : int)
signal health_regeneration_timer_timeout

const DIFFICULTY_INTERVAL = 5 # The time that must pass before the difficulty level is increased

@export var end_screen_scene : PackedScene

@onready var timer: Timer = $Timer
@onready var meta_health_regeneration_timer: Timer = $MetaHealthRegenerationTimer

var arena_difficulty = 0 # Current arena difficulty level


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	meta_health_regeneration_timer.timeout.connect(on_meta_health_regeneration_timer_timeout)


func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL) # Calculate what the next time_left mark is before the difficulty is increased again
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increase.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()


func on_meta_health_regeneration_timer_timeout():
	health_regeneration_timer_timeout.emit()
