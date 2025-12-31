extends CanvasLayer

# Gestiona la transición entre escenas

# Variables
var current_scene = ""
var player_spawn_position = null

# Gestión per se
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade out":
		# Redirigir a escena tras animación fade
		if current_scene == "cabaña_inicial":
			get_tree().change_scene("res://scenes/inicio.tscn")
		elif current_scene == "a_Inicio2":
			get_tree().change_scene("res://scenes/inicio2.tscn")
		# Terminar animación
		$AnimationPlayer.play("Fade in")
	elif anim_name == "Fade in":
		$TransitionColorFade.visible = false
		
	elif anim_name == "Skull":
		# Redirigir a escena tras animación skull
		if current_scene == "inicio":
			get_tree().change_scene("res://combates/zona_batalla_abad.tscn")
		elif current_scene == "batalla_abad":
			get_tree().reload_current_scene()
			StatsPlayer.health = 20
		# Terminar animación
		$AnimationPlayer.play("Skull2")
	elif anim_name == "Skull2":
		$Skull_holder/Skull.visible = false
		$TransitionColorSkull.visible = false

# Animación de desvanecimiento / fundido en negro
func fade_transition():
	$TransitionColorFade.visible = true
	$AnimationPlayer.play("Fade out")

# Animación con calavera (combates)
func skull_transition():
	$TransitionColorSkull.visible = true
	$Skull_holder/Skull.visible = true
	$AnimationPlayer.play("Skull")
