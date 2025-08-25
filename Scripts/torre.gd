extends CharacterBody2D

@export var projetil_scena : PackedScene 
@export var granada_scena: PackedScene
@export var perfurante_scene : PackedScene
@export_category("Configurações Torre")
@export var velocidade = 250
@export var dano_da_torre = 35

var alvo_atual = null
var alvos_no_alcance = []
var alvos_ordenados = []
var tem_dano_area = false
var tem_tiro_perfurante = false
var contagem_de_perfuracoes = 1
var tamanho_do_dano_area = 0
var tipo_de_projetil_atual = "normal"
var tamanho_atual_da_explosao = 5.0


#referencia direta a cena Maker2d sem usar a funcao ready
@onready var maker = $Marker2D
@onready var timer = $alcance/TimerNormal
@onready var alcance = $alcance
@onready var timer_granada = $alcance/TimerGranada
@onready var timer_perfurante = $alcance/TimerPerfurante


func _ready() -> void:
	global_position = Vector2((1280/2), (720/2))

func _process(delta: float) -> void:
	var lista_apagar = []
	
	for i in alvos_no_alcance:
		if is_instance_valid(i): #o alvo no alcance esta instaciado ou vivo?
			pass
		else:
			lista_apagar.append(i) # se não esta vivo coloque ele na lista pra apagar
	
	for i in lista_apagar: 
		alvos_no_alcance.erase(i) #so fica no alvos no alcance quem esta vivo
	
	alvos_no_alcance.sort_custom(sort_ascending) #ordeno os alvos de quem esta mais proximo da torre
	
	if len(alvos_no_alcance) != 0:
		look_at(alvos_no_alcance[0].global_position)
	else:
		rotation_degrees = 270

func sort_ascending(a, b):
		if a.global_position.distance_squared_to(global_position) < b.global_position.distance_squared_to(global_position):
			return true
		else:
			return false

func _on_timer_timeout() -> void:
	if len(alvos_no_alcance) != 0:
		var alvo_atual = alvos_no_alcance[0]
		look_at(alvo_atual.global_position)
		var projetil = projetil_scena.instantiate()
		projetil.dano_projetil = dano_da_torre
		projetil.global_position = maker.global_position
		projetil.rotation = maker.global_rotation
		get_parent().add_child(projetil)
			
func _on_timer_granada_timeout() -> void:
	if len(alvos_no_alcance) != 0:
		var alvo_atual = alvos_no_alcance[-1]
		look_at(alvo_atual.global_position)
		var granada = granada_scena.instantiate()
		granada.global_position = maker.global_position
		granada.rotation = maker.global_rotation
		granada.tem_dano_em_area = tem_dano_area
		granada.tamanho_atual_da_explosao = tamanho_atual_da_explosao
		get_parent().add_child(granada)

func _on_timer_perfurante_timeout() -> void:
	if len(alvos_no_alcance) != 0:
		if len(alvos_no_alcance) >= 2:
			var alvo_atual = alvos_no_alcance[1]
			look_at(alvo_atual.global_position)
		else:
			alvo_atual = alvos_no_alcance[0]
			look_at(alvo_atual.global_position)
		var perfurante = perfurante_scene.instantiate()
		perfurante.global_position = maker.global_position
		perfurante.rotation = maker.global_rotation
		perfurante.tem_tiro_perfurante = tem_tiro_perfurante
		perfurante.contagem_de_perfuracoes = contagem_de_perfuracoes
		get_parent().add_child(perfurante)

func _on_alcance_body_entered(body: Node2D) -> void:
	alvos_no_alcance.append(body)

func _on_alcance_body_exited(body: Node2D) -> void:
	if body in alvos_no_alcance:
		alvos_no_alcance.erase(body)

func aplicar_melhoria(dicionario_melhoria):
	var nome_do_upgrade = dicionario_melhoria["tipo_upgrade"] #"aumentar_alcance"
	var valor_do_upgrade = dicionario_melhoria["valor"] #0.05
	if nome_do_upgrade == "aumentar_dano":
		aumentar_dano(valor_do_upgrade)
	elif nome_do_upgrade == "aumentar_velocidade":
		aumentar_velocidade_ataque(valor_do_upgrade)
	elif nome_do_upgrade == "aumentar_alcance":
		aumentar_alcance(valor_do_upgrade)
	elif nome_do_upgrade == "dano_em_area":
		aumentar_dano_area(valor_do_upgrade)
	elif nome_do_upgrade == "tiro_perfurante":
		ativar_tiro_perfurante(valor_do_upgrade)

func ativar_tiro_perfurante(valor_do_upgrade):
	contagem_de_perfuracoes += valor_do_upgrade
	timer_perfurante.start()

func aumentar_dano_area(valor_do_upgrade):
	tamanho_atual_da_explosao += valor_do_upgrade
	timer_granada.start()

func aumentar_dano(valor_do_upgrade):
	dano_da_torre += valor_do_upgrade
func aumentar_velocidade_ataque(valor_do_upgrade):
	timer.wait_time = timer.wait_time - (timer.wait_time * valor_do_upgrade)
func aumentar_alcance(valor_do_upgrade):
	alcance.scale = alcance.scale + (alcance.scale * valor_do_upgrade)
