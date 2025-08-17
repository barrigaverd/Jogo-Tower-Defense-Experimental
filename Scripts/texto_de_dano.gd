extends Label

@export_category("Configurações do texto flutuante")
@export var velocidade_do_texto = 20
@export var transparancia = 1

func _process(delta: float) -> void:
	global_position.y -= velocidade_do_texto * delta
	modulate.a = clamp((modulate.a - transparancia * delta), 0, 1)
	
	if modulate.a == 0:
		queue_free()
