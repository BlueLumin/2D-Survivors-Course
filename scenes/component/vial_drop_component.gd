extends Node

@export_range(0, 1) var drop_percent : float = 0.5
@export var health_component : Node
@export var vial_scene : PackedScene


func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	var adjusted_drop_percect = drop_percent
	var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	
	if experience_gain_upgrade_count > 0:
		adjusted_drop_percect += (0.10 * experience_gain_upgrade_count)
		adjusted_drop_percect = min(1, adjusted_drop_percect)
	
	if randf() > adjusted_drop_percect: # If random chance is not within drop percent chance, then return.
		return
	
	if vial_scene == null: # If there is no vial scene, then don't proceed.
		return
	
	if not owner is Node2D: # Check that the owner is a Node2D.
		return
	
	var spawn_position = (owner as Node2D).global_position # Get the owner's position (the enemy's position).
	var vial_instance = vial_scene.instantiate() as Node2D # Create the instance in a variable.
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") # Get the layer which the entites are instanced under.
	entities_layer.add_child(vial_instance) # Instance the vial.
	vial_instance.global_position = spawn_position # Move the vial to the enemy's position.
