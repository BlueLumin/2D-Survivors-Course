extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU)) # Start the axe rotation in a random direction from the player
	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3) # from value, to value (how many rotations), duration
	tween.tween_callback(queue_free) # Once the tween is done, call method queue_free


func tween_method(rotations: float):
	var percent = rotations / 2 # How far along in the rotations we are (2 being the max we passed through in the tween_method)
	var current_radius = percent * MAX_RADIUS # Increasing the radius (how far away from the player the axe is) by how far along in the total roations we are (2)
	var current_direction = base_rotation.rotated(rotations * TAU) # roations is a float. At 0 rotations, the degrees will be 0. At 1 rotation the degrees is 360 (one full circle)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
