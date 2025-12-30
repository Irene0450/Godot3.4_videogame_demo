extends CanvasLayer

# Variables
onready var map = $ControlMapa
onready var inv = $ControlInventario

# Funciones

func _ready():
	map.close()
	inv.close()

func _input(event):
	if event.is_action_pressed("toggle_map"):
		if map.isOpen:
			map.close()
			get_tree().paused = false
		else:
			map.open()
			inv.close()
			get_tree().paused = true
	if event.is_action_pressed("toggle_inv"):
		if inv.isOpen:
			inv.close()
			get_tree().paused = false
		else:
			inv.open()
			map.close()
			get_tree().paused = true
