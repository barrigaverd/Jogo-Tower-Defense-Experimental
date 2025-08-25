extends Area2D

@export_category("Configurações do Projétil")
@export var velocidade = 500
var dano_projetil = 30
@onready var area_explosao = $AreaDeExplosao
@onready var explosao = $AreaDeExplosao/SpriteExplosao
var tem_dano_em_area = false
var tamanho_atual_da_explosao = 0
var ja_explodiu = false

func _process(delta: float) -> void:
	var direcao = Vector2.DOWN.rotated(rotation)
	var caminho = direcao * velocidade * delta
	position += caminho
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("receber_dano"):
		if ja_explodiu == true:
			return
		else:
			ja_explodiu = true
			area_explosao.scale.x = tamanho_atual_da_explosao
			area_explosao.scale.y = tamanho_atual_da_explosao
			explosao.visible = true
			$Sprite2D.visible = false
			velocidade = 0
			var inimigos = area_explosao.get_overlapping_bodies()
			for i in inimigos:
				i.receber_dano(dano_projetil)
			var tween = create_tween()
			tween.tween_property(explosao, "modulate", Color(1,1,1,0), 1)
			await tween.finished
			queue_free()
