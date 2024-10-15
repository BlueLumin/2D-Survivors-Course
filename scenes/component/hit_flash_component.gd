extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	health_component.health_decreased.connect(on_health_decreased)
	sprite.material = hit_flash_material


func on_health_decreased():
	# Checks if there is a tween already running and then removes it.
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	# Set the shader lerp_percent to 1.0 (white) before tweening it back to 0.0.
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	
	# Create a new tween.
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
