extends Node2D

const HIT_FLASH_COMPONENT_MATERIAL = preload("res://scenes/component/hit_flash_component_material.tres")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var health_component : Node
@export var sprite : Sprite2D

func _ready() -> void:
	gpu_particles_2d.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if owner == null or not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	
	# Remove self from parent (enemy) and place self into the Entities node
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	animation_player.play("default")
	
	$AudioStreamPlayer2D.play()
