extends Control

@onready var main_view: Control = $MainView
@onready var case_selection_view: Control = $CaseSelectionView

@onready var btn_modo_historia: TextureButton = $MainView/MenuContainer/BtnModoHistoria
@onready var btn_opcoes: TextureButton = $MainView/MenuContainer/BtnOpcoes
@onready var btn_sair: TextureButton = $MainView/MenuContainer/BtnSair

@onready var btn_tutorial: TextureButton = $CaseSelectionView/TutorialButton
@onready var padlock: TextureRect = $CaseSelectionView/TutorialButton/TutorialContent/PadlockWrapper/Padlock
@onready var case_01: TextureRect = $CaseSelectionView/CasesContainer/Case01
@onready var fade_overlay: ColorRect = $FadeOverlay

var padlock_tween: Tween
var is_transitioning: bool = false

func _ready() -> void:
	btn_modo_historia.pressed.connect(_on_modo_historia_pressed)
	btn_opcoes.pressed.connect(_on_opcoes_pressed)
	btn_sair.pressed.connect(_on_sair_pressed)
	btn_tutorial.pressed.connect(_on_tutorial_pressed)
	
	# Verificar se o Caso 01 já foi desbloqueado através do GameState
	if GameState.case_01_unlocked:
		case_01.texture = preload("res://artwork/ui/scene-case-01-unlocked.png")
		main_view.position.x = -1280.0
		case_selection_view.position.x = 0.0
		_start_padlock_bounce()

func _on_modo_historia_pressed() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	# Desabilita botões do menu durante a transição
	btn_modo_historia.disabled = true
	btn_opcoes.disabled = true
	btn_sair.disabled = true

	# Animação: MainView sai para a esquerda (-1280) e CaseSelectionView entra pela direita (1280 -> 0)
	var transition_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	transition_tween.tween_property(main_view, "position:x", -1280.0, 0.65)
	transition_tween.tween_property(case_selection_view, "position:x", 0.0, 0.65)
	
	transition_tween.chain().tween_callback(_on_case_selection_entered)

func _on_case_selection_entered() -> void:
	is_transitioning = false
	_start_padlock_bounce()

func _start_padlock_bounce() -> void:
	if padlock_tween and padlock_tween.is_valid():
		padlock_tween.kill()
	
	padlock_tween = create_tween().set_loops()
	var base_y: float = padlock.position.y
	
	# Salto para cima
	padlock_tween.tween_property(padlock, "position:y", base_y - 12.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Retorno para a posição base com leve efeito elástico/bounce
	padlock_tween.tween_property(padlock, "position:y", base_y, 0.35).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# Pequena pausa antes do próximo salto
	padlock_tween.tween_interval(0.3)

func _on_tutorial_pressed() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	fade_overlay.visible = true
	fade_overlay.color.a = 0.0
	
	var fade_tween = create_tween()
	fade_tween.tween_property(fade_overlay, "color:a", 1.0, 0.45)
	fade_tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
	)

func _on_opcoes_pressed() -> void:
	print("Opções selecionadas.")

func _on_sair_pressed() -> void:
	get_tree().quit()
