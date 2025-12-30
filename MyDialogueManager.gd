extends Node

func show_dialogue(title: String, local_resource: DialogueResource = null, extra_game_states: Array = []) -> void:
	get_tree().paused = true
	var dialogue_line = yield(DialogueManager.get_next_dialogue_line(title, local_resource, extra_game_states), "completed")
	if dialogue_line != null:
		var balloon = preload("res://balloon/Dialogue_box.tscn").instance()
		balloon.pause_mode = PAUSE_MODE_PROCESS
		balloon.dialogue_line = dialogue_line
		get_tree().current_scene.add_child(balloon)
		show_dialogue(yield(balloon, "actioned"), local_resource, extra_game_states)

#Para añadir un nuevo diálogo tienes que situarte en la pestaña de 2D, hacer click en el NPC y a la derecha,
#en Script Variables, adjuntar el archivo dialogue.tres y poner el nombre del diálogo (en la pestaña
#Dialogue, lo que empieza por ~)

#NOTA: antes de hacer eso, asegúrate de que tiene un script con el código de 'Cama roja'
