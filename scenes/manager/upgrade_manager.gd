extends Node

@export var experience_manager : ExperienceManager
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {} # The upgrades the player currently has active
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_anvil_count = preload("res://resources/upgrades/anvil_count.tres")


func _ready() -> void:
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_anvil, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	
	experience_manager.level_up.connect(on_level_up)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_count, 5)


func apply_upgrade(upgrade : AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id) # Return true or false depending on whether or not the chosen upgrade is already an active upgrade
	if !has_upgrade: # If we don't have the upgrade, add it to the list of active upgrades with nested keys for the resource and quantity
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else: # If we already have the upgrade, then add 1 to the "quantity" nested key
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity >= upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = [] # An empty Array
	for i in 2: # Choose two random upgrades to display
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break # If there are no more upgrades to chose from, then break out of the loop
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade) # Add each chosen upgrade
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(new_level : int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
