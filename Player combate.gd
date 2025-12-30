extends Node2D

func _ready():
	$ProgressBar.value = StatsPlayer.health * 100 / StatsPlayer.max_health
	$AnimationPlayer.play("Idle")
	SceneManager.current_scene = "BatallaAbad"

func weapon():
	if StatsPlayer.has_sword == false:
		$AnimationPlayer.play("Normal attack (staff)")
		StatsPlayer.damage = randi() % 3 + 1
	else:
		$AnimationPlayer.play("Normal attack (sword)")
		StatsPlayer.damage = randi() % 3 + 4

signal HideOptions

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		SceneManager.skull_transition()
		Global.restore_inventory()
	elif StatsPlayer.health <= 0:
		$AnimationPlayer.play("Death")
		emit_signal("HideOptions")
	else:
		$AnimationPlayer.play("Idle")

		

func _on_attack_made():
	$AnimationPlayer.play("Damage")
	$Node2D.visible = true
	$Node2D/Label.text = str(StatsPlayer.damage_received)
	StatsPlayer.health -= StatsPlayer.damage_received
	$ProgressBar.value = StatsPlayer.health * 100 / StatsPlayer.max_health
	if StatsPlayer.health > 0:
		get_parent().get_node("Options").show()
	else:
		pass

func strong_damage_made_roulette():
	if StatsPlayer.has_sword == false:
		$AnimationPlayer.play("Strong attack (staff)")
		StatsPlayer.damage = randi() % 3 + 5
	else:
		$AnimationPlayer.play("Strong attack (sword)")
		StatsPlayer.damage = randi() % 4 + 8

func strong_damage_received_roulette():
	get_parent().get_node("Abad combate").get_node("AnimationPlayer").play("Ataque")


func apply_item_effect(item: Dictionary):
	if item["type"] == "Curación":
		StatsPlayer.health = StatsPlayer.health + 3
		if StatsPlayer.health > StatsPlayer.max_health:
			StatsPlayer.health = StatsPlayer.max_health 
		$ProgressBar.value = StatsPlayer.health * 100 / StatsPlayer.max_health
		print("Se usó poción, vida actual:", StatsPlayer.health)
