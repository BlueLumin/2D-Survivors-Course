extends PanelContainer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var name_label : Label = $%NameLabel
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var purchase_button: Button = %PurchaseButton

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade : MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = 0 
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id): # Check if upgrade is in save.
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	
	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 or is_maxed # Disable the button if at max quantity or not enough currency.
	if is_maxed: # If reached max quantity, then disable button and change the text.
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_quantity


func select_card():
	animation_player.play("selected")


func on_purchase_pressed():
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")
