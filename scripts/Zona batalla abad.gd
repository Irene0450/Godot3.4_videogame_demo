extends Node2D

func _enter_tree() -> void:
	Global.set_context("combat")

func _ready():
	get_node("Abad combate").connect("attack_made", self, "_on_attack_made")
	Global.set_player_reference($"Player combate") 
	#Global.set_context("combat") # opcional, ya hecho
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"Player combate".connect("HideOptions", self, "on_HideOptions")
	Global.save_inventory()


func on_HideOptions():
	get_node("Options").hide()

func _on_Normal_Attack_Button_pressed():
	get_node("Options").hide()
	get_node("Player combate").weapon()
	get_node("Abad combate").damage_received = StatsPlayer.damage
	get_node("Abad combate").health -= StatsPlayer.damage
	get_node("Abad combate").damage()


func _on_attack_made():
	get_node("Player combate")._on_attack_made() 

var current_roulette: Node2D = null

func _on_Special_Attack_Button_pressed():
	get_node("Options").hide()
	var path: String
	if StatsPlayer.roulette_is_upgraded == true: #true cuando usar objeto 
		path = "res://Combates/RuletaPotenciadaScene.tscn"
		StatsPlayer.roulette_is_upgraded = false
	else:
		path = "res://Combates/RuletaScene.tscn"
	show_roulette(path)

func show_roulette(path: String):
	current_roulette = load(path).instance()
	$CanvasLayer.add_child(current_roulette)
	current_roulette.position = Vector2(190, 50)
	current_roulette.connect("roulette_result", self, "_on_roulette_result")
	current_roulette._start_roullete()

func _on_roulette_result(result: String):
	if result == "acertar":
		get_node("Player combate").strong_damage_made_roulette()
		var damage = StatsPlayer.damage
		get_node("Abad combate").damage_received = damage
		get_node("Abad combate").health -= damage
		get_node("Abad combate").damage()
	else:
		get_node("Player combate").strong_damage_received_roulette()

func _on_Use_Item_Button_pressed():
	get_node("Options").hide()
	get_node("Inventario").show()

func _on_Button_pressed():
	get_node("Options").show()
	get_node("Inventario").hide()
