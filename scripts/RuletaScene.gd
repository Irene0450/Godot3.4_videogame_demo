extends Node2D

func _ready():
	randomize()

export (int) var _roullete_rounds: int = 5
var _current_round: int = 0
export (int) var _roullete_speed: int = 100 # porcentaje
var _can_move_roullete: bool = false
export (float) var _rate: float = 20.0
var _selected_area: Area2D = null


func _process(delta: float) -> void:
	if _can_move_roullete:
		if _roullete_speed > 0 and $Timer.is_stopped():
			_roullete_speed -= 1
		if _roullete_speed > 0:
			_speed_up_roullete(delta)


func _speed_up_roullete(delta: float):
	$SpriteRuleta.rotation_degrees += _roullete_speed * delta


func _start_roullete() -> void:	
	_current_round = 0
	_roullete_speed = randi() % 150 + 200
	_selected_area = null
	
	$SpriteRuleta.rotation_degrees = 0
	
	for node in $SpriteRuleta.get_children():
		for child in node.get_children():
			child.disabled = false
		
	_can_move_roullete = false
	$Delay.start()

signal roulette_result(result) 

func _on_Timer_timeout() -> void:
	_current_round += 1
	_roullete_speed = _roullete_speed - (_rate * _roullete_speed) / 100
	if _current_round >= _roullete_rounds:
		$Timer.stop()
		print("Area ganadora: ", _selected_area.name)
		if _selected_area.name == "Area acertar":
			emit_signal("roulette_result", "acertar")
		elif _selected_area.name == "Area fallar":
			emit_signal("roulette_result", "fallar")
		else:
			print("Area acertar/fallar no encontrada")
		queue_free()



func _on_AreaManecilla_area_entered(area: Area2D) -> void:
	_selected_area = area


func _on_Delay_timeout():
	_can_move_roullete = true
	$Timer.start()

