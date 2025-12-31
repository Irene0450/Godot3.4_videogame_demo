extends Control

# Variables
onready var icon = $SlotSprite/ItemIcon
onready var quantity_label = $SlotSprite/ItemQuantity
onready var details_panel = $DetailsPanel
onready var item_name = $DetailsPanel/ItemName
onready var item_type = $DetailsPanel/ItemType
onready var item_effect = $DetailsPanel/ItemEffect
onready var usage_panel = $UseDropPanel
onready var drop = $UseDropPanel/Drop
var item = null

# Señales
signal drag_start(slot)
signal drag_end

# Funciones
func _ready():
	_apply_context_rules()
	if not Global.is_connected("context_changed", self, "_on_context_changed"):
		Global.connect("context_changed", self, "_on_context_changed")
	call_deferred("_apply_context_rules")

# Cambio de contexto entre parte "world" (mundo abierto) y combates ----
func _on_context_changed(_ctx):
	_apply_context_rules()
	
func _apply_context_rules():
	if is_instance_valid(drop):
		var in_combat = Global.current_context == "combat"
		drop.disabled = in_combat
		drop.visible = not in_combat

# Visibilidad
func _on_Button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_Button_mouse_exited():
	details_panel.visible = false

# Vaciar
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# Insertar item (textura, cantidad...)
func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else:
		item_effect.text = ""

# Botones usar / tirar
func _on_Drop_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 20) # Radio desde jugador en el que se tira item
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		usage_panel.visible = false


func _on_Use_pressed():
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if Global.player_node and Global.player_node.has_method("apply_item_effect"): # Si tiene un efecto que aplicar se aplica
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])
		else:
			print("Player no se encuentra")

# Arrastrar (pendiente de revisión)
func _on_Button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
		if event.button_index == 2:
			if event.is_pressed():
				emit_signal("drag_start", self)
			else:
				emit_signal("drag_end")
