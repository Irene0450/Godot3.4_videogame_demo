extends Node

# Script siempre cargado

# Variables
var inventory = []
var saved_inventory = [] 
var player_node: Node = null
var current_context := "world"
onready var inventory_slot_scene = preload("res://scenes/slot.tscn")

# Señales
signal inventory_updated 
signal context_changed(new_context)

# Funciones
func save_inventory():
	saved_inventory.clear()
	for item in inventory:
		if item != null:
			saved_inventory.append(item.duplicate(true)) 
		else:
			saved_inventory.append(null)

func restore_inventory():
	inventory.clear()
	for item in saved_inventory:
		if item != null:
			inventory.append(item.duplicate(true))
		else:
			inventory.append(null)
	emit_signal("inventory_updated")

func set_context(new_context: String) -> void:
	if current_context != new_context:
		current_context = new_context
		emit_signal("context_changed", new_context)

func _ready():
	inventory.resize(15)
	randomize() 

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			emit_signal("inventory_updated")
			return true
		elif inventory[i] == null:
			inventory[i] = item
			emit_signal("inventory_updated")
			return true
	return false

func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			emit_signal("inventory_updated")
			return true
	return false

func increase_inventory_size():
		emit_signal("inventory_updated")

func set_player_reference(player):
	player_node = player

func adjust_drop_position(position):
	var radius = 20
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(rand_range(-radius, radius), rand_range(-radius, radius))
			position += random_offset
			break
	return position

func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instance() 
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)

func swap_inventory_items(index1, index2): # Revisar
	if index1 < 0 or index1 >= inventory.size() or index2 < 0 or index2 >= inventory.size():
		return false
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	emit_signal("inventory_updated")
	return true
