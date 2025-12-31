extends Control

# Complementario con canvas_layer.gd

var isOpen: bool = false

func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false
	
