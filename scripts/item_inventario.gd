tool
extends Node2D

# Variables
export var item_type = ""
export var item_name = ""
export var item_texture: Texture
export var item_effect = "" 
var scene_path: String = "res://scenes/item_inventario.tscn"
onready var icon_sprite = $Sprite
var player_in_range = false

# Funciones
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

# warning-ignore:unused_argument
func _process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		print("item obtenido")
		pickup_item()

func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"texture" : item_texture,
		"effect" : item_effect,
		"scene_path" : scene_path
	}
	if Global.player_node:
		var added = Global.add_item(item)
		if added:
			print("Ítem recogido y añadido al inventario:", item)
		else:
			print("No se pudo agregar el ítem al inventario.")
		self.queue_free()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true


func set_item_data(data):
	item_type = data["type"]
	item_name = data ["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
