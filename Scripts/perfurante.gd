extends Area2D

@export_category("Configurações do Projétil")
@export var velocidade = 500
var dano_projetil = 25

var tem_tiro_perfurante = false
var inimigos_atingidos = []
var contagem_de_perfuracoes = 1
var ja_atingiu_nesse_frame = false

func _process(delta: float) -> void:
	var direcao = Vector2.DOWN.rotated(rotation)
	var caminho = direcao * velocidade * delta
	position += caminho
	
	ja_atingiu_nesse_frame = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("receber_dano"):
		if ja_atingiu_nesse_frame == true:
			return
		else:
			ja_atingiu_nesse_frame = true
			if body in inimigos_atingidos:
				pass
			else:
				if  (len(inimigos_atingidos) + 1) <= contagem_de_perfuracoes: # 1 / 2
					body.receber_dano(dano_projetil) #do dano no inimigo 1 / dano no inimigo 2
					inimigos_atingidos.append(body) # coloco ele na lista de acertados ["inimigo1"] / coloco ele na lista de acertados ["inimigo1", "inimigo2"]
				else:
					queue_free()
				
