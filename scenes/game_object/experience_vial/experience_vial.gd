extends Node2D

@onready var area2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area2d.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90) # Add 90 because our sprite faces up (270 degrees) by default.
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(other_area : Area2D):
	Callable(disable_collision).call_deferred() # This calls this method on the next idle frame, so outside of the physics_process.
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1).set_delay(0.4)
	tween.chain() # Wait for all previous tweens to finish before moving onto the next tweens.
	tween.tween_callback(collect)
