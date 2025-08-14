extends CharacterBody2D

signal morreu(valor_recompensa)

@export_category("Configurações do Inimigo")
@export var velocidade = 50
@export var vida = 40

func _process(delta: float) -> void:
	var direcao = Vector2(0, 1)
	var caminho = direcao * velocidade * delta
	position += caminho

func receber_dano(dano_recebido):
	vida -= dano_recebido
	print("O inimigo tomou, ", dano_recebido, " de dano!")
	if vida <= 0:
		print("O inimigo Morreu!")
		morreu.emit(10)
		queue_free()
