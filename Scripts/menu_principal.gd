extends Control

@onready var botao_iniciar = $PanelContainer/VboxContainer/ButtonIniciar
@onready var botao_sair = $PanelContainer/VboxContainer/ButtonSair

func _ready() -> void:
	botao_sair.pressed.connect(_sair_do_jogo)
	botao_iniciar.pressed.connect(_iniciar_jogo)
	
func _sair_do_jogo():
	get_tree().paused = false
	get_tree().quit()
	
func _iniciar_jogo():
	get_tree().change_scene_to_file("res://Cenas/mundo.tscn")
