extends Node2D

# Variables
var health = 16
var damage = randi() % 2 + 1 # random
var max_health = 16
var damage_received = 0
var attack_is_strong = false

# Señales
signal attack_made

# Funciones
func _ready():
	$Node2D.visible = false
	$ProgressBar.value = health * 100 / max_health
	$AnimationPlayer.play("Idle")

func _process(delta):
	pass

func damage():
	$Node2D.visible = true
	$Node2D/Label.text = str(damage_received) # Etiqueta con el valor del daño
	$AnimationPlayer.play("Damage")
	$ProgressBar.value = health * 100 / max_health # Actualizar barra salud

func _on_AnimationPlayer_animation_finished(anim_name):
	if health <= 0:
		if anim_name == "Damage":
			$AnimationPlayer.play("Death")
		elif anim_name == "Death":
			SceneManager.current_scene = "a_Inicio2" # Redirigir
			SceneManager.fade_transition()
	else:
		if anim_name == "Damage":
			$AnimationPlayer.play("Ataque")
		elif anim_name == "Ataque":
			StatsPlayer.damage_received = damage
			emit_signal("attack_made")
			$AnimationPlayer.play("Idle")
	
