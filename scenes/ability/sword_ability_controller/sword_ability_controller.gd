extends Node

const MAX_RANGE = 150

@export var sword_ability : PackedScene

@onready var timer: Timer = $Timer

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time


func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy : Node2D): # The filter func will filter the array to only include enemies that are within the MAX_RANGE reletive to the player's position
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	# The sort_custom func will sort the filtered enemies in the Array to have the enemy closest to the player first (at index 0)
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	sword_instance.global_position = enemies[0].global_position # In the sorted and filtered enemies array, taking the enemy at index 0 means we take the closest enemy to the player
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4 # This will change the global position of the sword to a random place within a full circle (360 degrees) around it's original position with a radius of 4 pixels
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.10 # Take the number of sword upgrades and multiply it by 10%
		timer.wait_time = base_wait_time * (1 - percent_reduction) # 1 being the full base_wait_time, then minus the "cooldown" percent from the upgrade
		timer.start() # Restart the timer using the new wait_time
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.25)
	
