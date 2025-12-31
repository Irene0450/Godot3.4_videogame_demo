extends Control

# Variables
onready var grid_container = $NinePatchRect/GridContainer 
var dragged_slot = null

# Funciones
func _ready():
	Global.connect("inventory_updated", self, "inventory_updated")
	inventory_updated()

func inventory_updated():
	clear_grid_container()
	#print("inventory_updated funciona")
	for item in Global.inventory:
		var slot = Global.inventory_slot_scene.instance()
		slot.connect("drag_start", self, "_on_drag_start")
		slot.connect("drag_end", self, "_on_drag_end")
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

# Borrar items
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

# Arrastrar items
func _on_drag_start(slot_control : Control):
	dragged_slot = slot_control
	print("_on_drag_start funciona", dragged_slot)

func _on_drag_end():
	print("_on_drag_end funciona")
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot) 
	dragged_slot = null

func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	print("Posición ratón:", mouse_position)
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.get_global_transform().origin, slot.rect_size)
		print("Slot Rect:", slot_rect)
		if slot_rect.has_point(mouse_position):
			print("Slot debajo ratón:", slot)
			return slot
	return null

# Identificar y soltar slot
func get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
			return i
	return -1 

func drop_slot(slot1: Control, slot2: Control): # Revisar
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		print("Slot inválido")
		return  
		print("Intercambiando slots:", slot1_index, slot2_index)
	else:
		if Global.swap_inventory_items(slot1_index, slot2_index):
			inventory_updated()
			print("Slots tirados:", slot1_index, slot2_index)
