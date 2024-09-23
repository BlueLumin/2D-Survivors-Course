extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D = $Visuals

var is_moving : bool = false


func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)


func _physics_process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	
	velocity_component.move(self)
	
	# Visuals
	if sign(velocity.x) != 0:
		visuals.scale.x = sign(velocity.x)


func set_is_moving(moving: bool):
	is_moving = moving 


func on_hit():
	$AudioStreamPlayer2D.play()
