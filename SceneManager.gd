extends CanvasLayer

var current_scene = ""
var player_spawn_position = null

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade out":
		#redirigir a escena tras fade
		if current_scene == "Cabaña inicial":
			get_tree().change_scene("res://Scenes/Inicio.tscn")
		elif current_scene == "Entrar_Casa_Esha":
			get_tree().change_scene("res://Scenes/CasaEsha.tscn")
		elif current_scene == "CasaEsha":
			get_tree().change_scene("res://Scenes/Inicio.tscn") # Falta configurar position
		elif current_scene == "a_Inicio2":
			get_tree().change_scene("res://Scenes/Inicio2.tscn")
		# terminar animación
		$AnimationPlayer.play("Fade in")
	elif anim_name == "Fade in":
		$TransitionColorFade.visible = false
		
		
	elif anim_name == "Skull":
		#redirigir a escena tras skull
		if current_scene == "Inicio":
			get_tree().change_scene("res://Combates/Zona batalla abad.tscn")
		elif current_scene == "BatallaAbad":
			get_tree().reload_current_scene()
			StatsPlayer.health = 20
		# terminar animación
		$AnimationPlayer.play("Skull2")
	elif anim_name == "Skull2":
		$Skull_holder/Skull.visible = false
		$TransitionColorSkull.visible = false

func fade_transition():
	$TransitionColorFade.visible = true
	$AnimationPlayer.play("Fade out")

func skull_transition():
	$TransitionColorSkull.visible = true
	$Skull_holder/Skull.visible = true
	$AnimationPlayer.play("Skull")
