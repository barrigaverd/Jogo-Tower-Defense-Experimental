extends Area2D

@export_category("Configurações do Projétil")
@export var velocidade = 500
var dano_projetil = 0

func _process(delta: float) -> void:
	var direcao = Vector2.DOWN.rotated(rotation)
	var caminho = direcao * velocidade * delta
	position += caminho
	


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("receber_dano"):
		body.receber_dano(dano_projetil)
		queue_free()
