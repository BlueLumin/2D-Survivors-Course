extends Node

signal experience_vial_collected(number : float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_uprgades: Dictionary)
signal player_damaged


func emit_experience_vial_collected(number : float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_uprgades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_uprgades)


func emit_player_damaged():
	player_damaged.emit()
