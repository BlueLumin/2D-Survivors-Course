extends Node

const SPAWN_RADIUS = 375

@onready var timer: Timer = $Timer

@export var basic_enemy_scene : PackedScene
@export var wizard_enemy_scene : PackedScene
@export var bat_enemy_scene : PackedScene
@export var arena_time_manager : Node

var base_spawn_time
var enemy_table = WeightedTable.new()
var number_to_spawn = 1


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increase.connect(on_arena_difficulty_increased)


func get_spawn_position(): # Get a random position in relation to the player to spawn the enemy.
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))  # Get a random position in a full circle.
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS) # Radius around the player.
		var additional_check_offset = random_direction * 20 # Creates a "safe area" when doing the ray check.
		
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1) # Instantiate the PhysicsRayQueryParameters2D node that can check for collisions between two positions.
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters) # direct_space_state is used to get access to the worlds collision and physics.
	
		if result.is_empty(): # If there are no collision, it returns an empty Dictonary.
			# We have no collisions in the way.
			break # break tells the loop to stop going.
		else:
			# Collision is in the way, rotate the random_direction by 90 degrees.
			random_direction = random_direction.rotated(deg_to_rad(90)) # deg_to_rad converts degrees to radians.
	
	return spawn_position


func on_timer_timeout(): # Spawn an enemy.
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: # If there is no player in the scene, then do not continue spawning enemies.
		return
	
	for i in number_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy)
		enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty : int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6: # 30 seconds
		enemy_table.add_item(wizard_enemy_scene, 15)
	elif arena_difficulty == 18: # 75 seconds 
		enemy_table.add_item(bat_enemy_scene, 6)
	
	# Increase the number of enemies that spawn at once.
	if (arena_difficulty % 18) == 0: # If the arena difficulty is evenly divisible by 18 (the 0 is the outcome).
		number_to_spawn += 1
