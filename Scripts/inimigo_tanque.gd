extends CharacterBody2D

signal morreu(valor_recompensa)

@export_category("Configurações do Inimigo_tanque")
@export var velocidade = 50
@export var vida = 40
@export var valor_do_inimigo = 25
@export var dano_na_base = 20
@export var texto_do_dano :PackedScene

func _process(delta: float) -> void:
	var direcao = Vector2(0, 1)
	var caminho = direcao * velocidade * delta
	position += caminho

func receber_dano(dano_recebido):
	vida -= dano_recebido
	
	texto_flutuante(dano_recebido)
	
	print("O inimigo tomou, ", dano_recebido, " de dano!")
	
	if vida <= 0:
		print("O inimigo Morreu!")
		morreu.emit(valor_do_inimigo)
		queue_free()

func texto_flutuante(dano_recebido):
	var texto_flutuante = texto_do_dano.instantiate()
	texto_flutuante.text = str(dano_recebido)
	texto_flutuante.global_position = $".".global_position
	get_parent().add_child(texto_flutuante)
