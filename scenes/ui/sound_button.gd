extends Button


func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed():
	$AudioStreamPlayer.play()
