extends CharacterBody2D

@export var projetil_scena : PackedScene 
@export_category("Configurações Torre")
@export var velocidade = 250
@export var dano_da_torre = 40
var alvo_atual = null
var alvos_no_alcance = []
#referencia da cena do projetil

#referencia direta a cena Maker2d sem usar a funcao ready
@onready var maker = $Marker2D
@onready var timer = $alcance/Timer
@onready var alcance = $alcance/CollisionShape2D

func _ready() -> void:
	global_position = Vector2((1280/2), (720/2))

func _process(delta: float) -> void:
	var direcao_movimento = Vector2.ZERO
	var direcaoy = 0
	if Input.is_action_pressed("ui_right"):
		direcao_movimento.x += 1
	if Input.is_action_pressed("ui_left"):
		direcao_movimento.x -= 1
	if Input.is_action_pressed("ui_down"):
		direcao_movimento.y += 1
	if Input.is_action_pressed("ui_up"):
		direcao_movimento.y -= 1

	direcao_movimento = direcao_movimento.normalized()
	
	velocity = direcao_movimento * velocidade

	move_and_slide()
	
	alvo_atual = null
	var menor_distancia = INF
	var lista_apagar = []
	
	for i in alvos_no_alcance:
		if is_instance_valid(i):
			var distancia_atual = global_position.distance_to(i.global_position)
			if distancia_atual < menor_distancia:
				menor_distancia = distancia_atual
				alvo_atual = i
		else:
			lista_apagar.append(i)
	alvos_no_alcance.erase(lista_apagar)
	
	if alvo_atual != null:
		look_at(alvo_atual.global_position)
	else:
		rotation_degrees = 270

func _on_timer_timeout() -> void:
	if alvo_atual != null:
		var projetil = projetil_scena.instantiate()
		projetil.dano_projetil = dano_da_torre
		projetil.global_position = maker.global_position
		projetil.rotation = maker.global_rotation
		get_parent().add_child(projetil)

func _on_alcance_body_entered(body: Node2D) -> void:
	alvos_no_alcance.append(body)

func _on_alcance_body_exited(body: Node2D) -> void:
	if body in alvos_no_alcance:
		alvos_no_alcance.erase(body)

func aplicar_melhoria(dicionario_melhoria):
	var nome_do_upgrade = dicionario_melhoria["tipo_upgrade"]
	var valor_do_upgrade = dicionario_melhoria["valor"]
	if nome_do_upgrade == "aumentar_dano":
		aumentar_dano(valor_do_upgrade)
	elif nome_do_upgrade == "aumentar_velocidade":
		aumentar_velocidade_ataque(valor_do_upgrade)
	elif nome_do_upgrade == "aumentar_alcance":
		aumentar_alcance(valor_do_upgrade)

func aumentar_dano(valor_do_upgrade):
	dano_da_torre += valor_do_upgrade
func aumentar_velocidade_ataque(valor_do_upgrade):
	timer.wait_time = timer.wait_time - (timer.wait_time * valor_do_upgrade)
func aumentar_alcance(valor_do_upgrade):
	alcance.scale = alcance.scale + (alcance.scale * valor_do_upgrade)
