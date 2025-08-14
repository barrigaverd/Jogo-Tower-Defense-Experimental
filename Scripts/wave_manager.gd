extends Node

@export var inimigo1_scene : PackedScene
@onready var dinheiro_label = $"../Dinheiro_Canva/Valor"
@onready var painel_upgrades = $"../Painel_Canva/PainelDeUpgrades"
@onready var botao_pular = painel_upgrades.get_child(0).get_child(3)
@onready var botao_1 = painel_upgrades.get_child(0).get_child(0)
@onready var botao_2 = painel_upgrades.get_child(0).get_child(1)
@onready var botao_3 = painel_upgrades.get_child(0).get_child(2)
@onready var torre = $"../Torre"
@onready var label_vida_base = $"../Vida_Canva/VidaBase"

var inimigos_vivos = 0

var dinheiro_jogador = 0
@export var vida_da_base = 100

var dicionario_de_ondas = {"Onda 1": 5, "Onda 2": 10, "Onda 3": 25, "Onda 4": 50}
var nome_das_ondas = []
var catalogo_de_upgrades = []
var onda_atual_index = 0

var upgrade_aumentar_dano = {
	"nome_para_mostrar": "Canhão Melhorado",
	"descricao": "Aumenta o dano dos projéteis em 5.",
	"custo": 100,
	"tipo_upgrade": "aumentar_dano"
}

var upgrade_aumentar_velocidade_ataque_torre = {
	"nome_para_mostrar": "+ Velocidade na Torre",
	"descricao": "Aumenta a velocidade de ataque da torre em 10%.",
	"custo": 100,
	"tipo_upgrade": "aumentar_velocidade"
}

var upgrade_alcance_melhorado = {
	"nome_para_mostrar": "Mira de Longo Alcance",
	"descricao": "Aumenta o alcance da torre em 15%.",
	"custo": 120,
	"tipo_upgrade": "aumentar_alcance"
}

func _ready() -> void:
	catalogo_de_upgrades.append(upgrade_aumentar_dano);
	catalogo_de_upgrades.append(upgrade_aumentar_velocidade_ataque_torre);
	catalogo_de_upgrades.append(upgrade_alcance_melhorado);
	
	botao_pular.pressed.connect(_on_botao_pular_pressionado)

	nome_das_ondas = dicionario_de_ondas.keys()
	
	label_vida_base.text = str(vida_da_base)
	
	iniciar_proxima_onda()
		
func _on_inimigo_morreu(valor):
	inimigos_vivos -= 1
	dinheiro_jogador += valor
	dinheiro_label.text = str(dinheiro_jogador)
	
	if inimigos_vivos <= 0:
		_mostrar_loja_de_upgrades()

func _mostrar_loja_de_upgrades():

	print("A ", nome_das_ondas[onda_atual_index], " acabou!")
	onda_atual_index += 1
	
	if onda_atual_index >= nome_das_ondas.size():
		print("VOCE VENCEU!")
		get_tree().quit()
	else:
		painel_upgrades.visible = true
		botao_pular.add_theme_color_override("font_color", Color.YELLOW)
		catalogo_de_upgrades.shuffle()
		
		var primeiro_item = catalogo_de_upgrades[0]
		var segundo_item = catalogo_de_upgrades[1]
		var terceiro_item = catalogo_de_upgrades[2]
		botao_1.pressed.disconnect(_on_upgrade_escolhido)
		botao_2.pressed.disconnect(_on_upgrade_escolhido)
		botao_3.pressed.disconnect(_on_upgrade_escolhido)
		
		if dinheiro_jogador < primeiro_item["custo"]:
			botao_1.disabled = true
		else:
			botao_1.disabled = false
		if dinheiro_jogador < segundo_item["custo"]:
			botao_2.disabled = true
		else:
			botao_2.disabled = false
		if dinheiro_jogador < terceiro_item["custo"]:
			botao_3.disabled = true
		else:
			botao_3.disabled = false
			
		botao_1.text = " - " + primeiro_item["nome_para_mostrar"] + " - \n Custa " + str(primeiro_item["custo"])
		botao_2.text = " - " + segundo_item["nome_para_mostrar"] + " - \n Custa " + str(segundo_item["custo"])
		botao_3.text = " - " + terceiro_item["nome_para_mostrar"] + " - \n Custa " + str(terceiro_item["custo"])
		botao_1.pressed.connect(_on_upgrade_escolhido.bind(primeiro_item))
		botao_2.pressed.connect(_on_upgrade_escolhido.bind(segundo_item))
		botao_3.pressed.connect(_on_upgrade_escolhido.bind(terceiro_item))
		botao_pular.text = " Pular (+10 Ouro) "
		

func _on_botao_pular_pressionado():
	dinheiro_jogador += 10
	dinheiro_label.text = str(dinheiro_jogador)
	iniciar_proxima_onda()

func _on_upgrade_escolhido(upgrade_clicado):
	dinheiro_jogador -= upgrade_clicado["custo"]
	dinheiro_label.text = str(dinheiro_jogador)
	torre.aplicar_melhoria(upgrade_clicado)
	
	iniciar_proxima_onda()
	
func iniciar_proxima_onda():
	painel_upgrades.visible = false
	var nome_da_onda_atual = nome_das_ondas[onda_atual_index]
	var quantidade_de_inimigos = dicionario_de_ondas[nome_da_onda_atual]
	
	print("Iniciando", nome_da_onda_atual)
	
	for ini in range(quantidade_de_inimigos):
		inimigos_vivos += 1
		# 1. Crie um NOVO inimigo a cada repetição
		var inimigo = inimigo1_scene.instantiate()
		# 2. Espere um pouco
		await  get_tree().create_timer(0.5).timeout
		# 3. Defina a posição e adicione à cena
		var largura_da_tela = get_viewport().get_visible_rect().size.x
		var x_aleatorio = randf_range(0, largura_da_tela)
		inimigo.position = Vector2(x_aleatorio, -50)
		get_parent().add_child(inimigo)
		inimigo.morreu.connect(_on_inimigo_morreu)


func _on_linha_de_chegada_body_entered(body: Node2D) -> void:
	vida_da_base -= 10
	label_vida_base.text = str(vida_da_base)
	_on_inimigo_morreu(0)
	body.queue_free()
	if vida_da_base <= 0:
		print("Game Over!")
		var tela_fim_jogo = $"../Tela_Game_Over/PanelContainer"
		var botao_reiniciar = tela_fim_jogo.get_child(0).get_child(1)
		var botao_quit = tela_fim_jogo.get_child(0).get_child(2)
		botao_reiniciar.pressed.connect(_reiniciar_jogo)
		botao_quit.pressed.connect(_sair_do_jogo)
		get_tree().paused = true
		tela_fim_jogo.visible = true

func _reiniciar_jogo():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _sair_do_jogo():
	get_tree().paused = false
	get_tree().quit()
