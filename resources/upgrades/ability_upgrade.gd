extends Resource
class_name AbilityUpgrade

@export var id: String ## Reference id in code.
@export var max_quantity: int ## How many times can the player get this upgrade. 0 being unlimited.
@export var name: String ## The display name of the upgrade
@export_multiline var description: String ## The display description of the upgrade
