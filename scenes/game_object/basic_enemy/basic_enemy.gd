extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)


func _physics_process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	# Visuals
	if sign(velocity.x) != 0:
		visuals.scale.x = sign(-velocity.x)


func on_hit():
	$AudioStreamPlayer2D.play()
