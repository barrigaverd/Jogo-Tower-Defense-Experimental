extends CharacterBody2D

signal morreu(valor_recompensa)
signal atacou_a_base(dano)

@export_category("Configurações do Inimigo")
@export var velocidade = 50
@export var vida = 20
@export var valor_do_inimigo = 5
@export var texto_do_dano :PackedScene
@export var dano_na_base = 5
@onready var torre = $"../Torre"
var ja_morreu = false

func _process(delta: float) -> void:
	var direcao =  torre.global_position - global_position
	direcao = direcao.normalized()
	look_at(torre.global_position)
	velocity = direcao
	velocity = velocity * velocidade
	
	
	var colisao = move_and_slide()
	if colisao:
		var col = get_last_slide_collision()
		col = col.get_collider()
		if col.is_in_group("torre"):
			atacou_a_base.emit(dano_na_base)
			texto_flutuante(dano_na_base)
			queue_free()

func receber_dano(dano_recebido):
	if ja_morreu:
		return
	else:
		vida -= dano_recebido
		texto_flutuante(dano_recebido)
		
		print("O inimigo tomou, ", dano_recebido, " de dano!")
		
		if vida <= 0:
			print("O inimigo Morreu!")
			ja_morreu = true
			morreu.emit(valor_do_inimigo)
			queue_free()
	
func texto_flutuante(dano_recebido):
	var texto_flutuante = texto_do_dano.instantiate()
	texto_flutuante.text = str(dano_recebido)
	texto_flutuante.global_position = global_position
	get_parent().add_child(texto_flutuante)
