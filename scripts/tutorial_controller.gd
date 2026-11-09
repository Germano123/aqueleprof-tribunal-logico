extends Control

const CSVDataManager = preload("res://scripts/csv_data_manager.gd")

enum State {
	INTRO_DIALOGUE,
	INVESTIGATION,
	EVIDENCE_PANEL,
	LARA_WEAK_ARGUMENT,
	OBJECTION,
	OBJECTION_EXPLANATION,
	LOGIC_MINIGAME,
	FINAL_CHALLENGE,
	TUTORIAL_COMPLETE
}

var current_state: State = State.INTRO_DIALOGUE

# Diálogos intro
var intro_dialogue_ids: Array[String] = ["T01", "T02", "T03"]
var intro_index: int = 0

# Investigação
var collected_evidences: Dictionary = {}
var min_evidences_notified: bool = false
var selected_evidence_id: String = ""

# Definição das evidências e objetos
var room_objects: Dictionary = {
	"MESA": { "csv_id": "I01", "name": "Mesa", "evidence_title": "Documentos Fora do Lugar", "evidence_desc": "Papeis e pastas importantes foram deixados espalhados e desordenados sobre a mesa de trabalho." },
	"GAVETA": { "csv_id": "I02", "name": "Gaveta", "evidence_title": "Chave da Sala", "evidence_desc": "Uma chave mestra foi encontrada dentro de uma gaveta entreaberta na escrivaninha." },
	"RELOGIO": { "csv_id": "I03", "name": "Relógio", "evidence_title": "Horário Parado: 18h32", "evidence_desc": "O relógio de parede da sala travou com os ponteiros marcando exatamente 18h32." },
	"PORTA": { "csv_id": "I04", "name": "Porta", "evidence_title": "Registro da Porta: 18h31", "evidence_desc": "O sistema eletrônico de acesso confirma que a porta principal foi destrancada às 18h31." },
	"JANELA": { "csv_id": "I05", "name": "Janela", "evidence_title": "Janela Trancada", "evidence_desc": "A janela permanece fechada e trancada pelo trinco interno, sem sinais de violação." },
	"LIXEIRA": { "csv_id": "I06", "name": "Lixeira", "evidence_title": "Fragmento de Papel", "evidence_desc": "Um pedaço de anotação rasgada contendo códigos numéricos foi recuperado do cesto de lixo." },
	"COMPUTADOR": { "csv_id": "I07", "name": "Computador", "evidence_title": "Log de Acesso: 18h28", "evidence_desc": "O computador da estação de trabalho registrou último logon e encerramento às 18h28." },
	"ESTANTE": { "csv_id": "I08", "name": "Estante", "evidence_title": "Livro Deslocado", "evidence_desc": "Um volume pesado de direito penal foi removido da prateleira e recolocado em posição incorreta." },
	"CAMERA": { "csv_id": "I09", "name": "Câmera", "evidence_title": "Gravação da Câmera", "evidence_desc": "Filmagem de vigilância do corredor mostra uma pessoa passando pelo acesso às 18h31." }
}

# Minigame Lógico
var logic_step: int = 0
var logic_questions: Array[Dictionary] = [
	{
		"csv_id": "L01",
		"concept": "1. VERDADEIRO OU FALSO",
		"question": "A porta foi aberta às 18h31. Isso é verdadeiro ou falso?",
		"options": [
			{ "text": "VERDADEIRO", "correct": true, "feedback": "Correto! O registro eletrônico da porta comprova que ela foi aberta às 18h31." },
			{ "text": "FALSO", "correct": false, "feedback": "Incorreto. A evidência do registro da porta prova que a afirmação é verdadeira." }
		]
	},
	{
		"csv_id": "L02",
		"concept": "2. NEGAÇÃO LÓGICA",
		"question": "Se a porta foi aberta às 18h31, qual é a sua negação lógica correta?",
		"options": [
			{ "text": "A porta NÃO foi aberta às 18h31.", "correct": true, "feedback": "Exato! A negação de uma proposição P é 'NÃO P'." },
			{ "text": "A porta foi aberta às 18h35.", "correct": false, "feedback": "Incorreto. Mudar o horário não é a negação estrita da proposição." }
		]
	},
	{
		"csv_id": "L03",
		"concept": "3. CONECTIVO LÓGICO: E (Conjunção)",
		"question": "Quando usamos 'E', ambas as afirmações devem ser verdadeiras. Qual afirmação composta é sustentada?",
		"options": [
			{ "text": "A porta abriu às 18h31 E o relógio parou às 18h32.", "correct": true, "feedback": "Perfeito! Ambas as proposições são fatos verificados nas evidências." },
			{ "text": "A porta abriu às 18h31 E o suspeito roubou a sala.", "correct": false, "feedback": "Incorreto. Não há prova concreta do roubo; a conjunção exige duas verdades comprovadas." }
		]
	},
	{
		"csv_id": "L04",
		"concept": "4. CONECTIVO LÓGICO: OU (Disjunção)",
		"question": "Com 'OU', basta uma proposição ser verdadeira. Qual afirmação abaixo é logicamente verdadeira?",
		"options": [
			{ "text": "A porta abriu às 18h31 OU a janela estava quebrada.", "correct": true, "feedback": "Correto! Como a primeira parte é verdadeira, toda a afirmação com OU se torna verdadeira." },
			{ "text": "A janela foi violada OU a sala foi queimada.", "correct": false, "feedback": "Incorreto. Nenhuma dessas proposições é verdadeira, logo a disjunção é falsa." }
		]
	},
	{
		"csv_id": "L05",
		"concept": "5. CONDICIONAL: SE... ENTÃO (Implicação)",
		"question": "Relacione condição e consequência: Qual implicação é sustentada pelos fatos?",
		"options": [
			{ "text": "SE a porta abriu às 18h31, ENTÃO houve acesso à sala.", "correct": true, "feedback": "Excelente! A abertura da porta implica acesso físico, mas não prova o crime." },
			{ "text": "SE a porta abriu às 18h31, ENTÃO ocorreu um roubo.", "correct": false, "feedback": "Incorreto! Essa foi justamente a falácia de Lara: abertura da porta não implica roubo." }
		]
	}
]

# Desafio Final
var final_challenge_index: int = 0

# Referências de nós
@onready var room_container: Control = $RoomContainer
@onready var hud: Control = $HUD
@onready var evidence_btn: TextureButton = $HUD/EvidenceBtn
@onready var evidence_counter_label: Label = $HUD/EvidenceBtn/CounterLabel

# Personagens
@onready var characters: Control = $Characters
@onready var mestre_sprite: TextureRect = $Characters/MestreSprite
@onready var lara_slot: Control = $Characters/LaraSlot

# Diálogo
@onready var dialogue_box: Control = $DialogueBox
@onready var speaker_label: Label = $DialogueBox/SpeakerLabel
@onready var dialogue_text: Label = $DialogueBox/DialogueText
@onready var next_indicator: Label = $DialogueBox/NextIndicator

# Painel de Evidências
@onready var evidence_panel: Control = $EvidencePanel
@onready var evidence_grid: HFlowContainer = $EvidencePanel/Content/ScrollContainer/EvidenceGrid
@onready var evidence_detail_title: Label = $EvidencePanel/Content/DetailBox/DetailTitle
@onready var evidence_detail_desc: Label = $EvidencePanel/Content/DetailBox/DetailDesc
@onready var btn_proceed_analysis: TextureButton = $EvidencePanel/Content/BtnProceedAnalysis
@onready var btn_close_evidence: Button = $EvidencePanel/Content/BtnCloseEvidence

# Objeção
@onready var objection_overlay: Control = $ObjectionOverlay
@onready var objection_banner: Label = $ObjectionOverlay/ObjectionBanner
@onready var flash_rect: ColorRect = $FlashRect

# Minigame Lógico
@onready var logic_panel: Control = $LogicPanel
@onready var logic_concept_label: Label = $LogicPanel/ConceptLabel
@onready var logic_prompt_label: Label = $LogicPanel/PromptLabel
@onready var logic_options_box: VBoxContainer = $LogicPanel/OptionsBox
@onready var logic_feedback_box: Control = $LogicPanel/FeedbackBox
@onready var logic_feedback_label: Label = $LogicPanel/FeedbackBox/FeedbackLabel
@onready var logic_btn_next: TextureButton = $LogicPanel/FeedbackBox/BtnNext

# Tela de Conclusão
@onready var complete_panel: Control = $CompletePanel
@onready var btn_start_case01: TextureButton = $CompletePanel/BtnStartCase01

# Controle de Typewriter
var full_current_text: String = ""
var is_typing: bool = false
var type_tween: Tween
var current_dialogue_callback: Callable

func _ready() -> void:
	CSVDataManager.load_csv()
	_set_dialogue_visible(false)
	_setup_room_buttons()
	_setup_evidence_panel()
	_setup_signals()
	_start_intro()

func _setup_signals() -> void:
	evidence_btn.pressed.connect(_on_evidence_btn_pressed)
	btn_close_evidence.pressed.connect(func(): evidence_panel.visible = false)
	btn_proceed_analysis.pressed.connect(_on_proceed_to_analysis_pressed)
	btn_start_case01.pressed.connect(_on_start_case01_pressed)
	logic_btn_next.pressed.connect(_on_logic_next_pressed)

func _setup_room_buttons() -> void:
	for obj_key in room_objects.keys():
		var btn = room_container.get_node_or_null("Obj_" + obj_key)
		if btn and btn is BaseButton:
			btn.pressed.connect(func(): _on_investigate_object(obj_key))

func _setup_evidence_panel() -> void:
	evidence_panel.visible = false
	btn_proceed_analysis.visible = false
	evidence_detail_title.text = "Selecione uma evidência"
	evidence_detail_desc.text = "Clique em um item da lista à esquerda para analisar seus detalhes concretos."

# =========================================================================
# SISTEMA DE DIÁLOGO E TYPEWRITER
# =========================================================================

func _set_dialogue_visible(is_vis: bool) -> void:
	dialogue_box.visible = is_vis
	characters.visible = is_vis

func _show_dialogue(speaker: String, text: String, on_complete: Callable = Callable()) -> void:
	_set_dialogue_visible(true)
	speaker_label.text = speaker
	full_current_text = text
	current_dialogue_callback = on_complete
	next_indicator.visible = false
	
	# Destacar personagem que está falando
	_set_speaker_focus(speaker)
	
	# Iniciar efeito typewriter
	dialogue_text.text = text
	dialogue_text.visible_ratio = 0.0
	is_typing = true
	
	if type_tween and type_tween.is_valid():
		type_tween.kill()
		
	var duration: float = max(0.4, text.length() * 0.025)
	type_tween = create_tween()
	type_tween.tween_property(dialogue_text, "visible_ratio", 1.0, duration)
	type_tween.tween_callback(func():
		is_typing = false
		next_indicator.visible = true
	)

func _set_speaker_focus(speaker: String) -> void:
	if speaker == "MESTRE":
		mestre_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		lara_slot.modulate = Color(0.5, 0.5, 0.6, 0.6)
	elif speaker == "LARA":
		mestre_sprite.modulate = Color(0.5, 0.5, 0.6, 0.6)
		lara_slot.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		mestre_sprite.modulate = Color(0.8, 0.8, 0.8, 0.8)
		lara_slot.modulate = Color(0.8, 0.8, 0.8, 0.8)

func _input(event: InputEvent) -> void:
	if not dialogue_box.visible:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			_handle_dialogue_click()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		_handle_dialogue_click()

func _handle_dialogue_click() -> void:
	if is_typing:
		# Pressionar Enter / clique durante a escrita = completar texto imediatamente
		if type_tween and type_tween.is_valid():
			type_tween.kill()
		dialogue_text.visible_ratio = 1.0
		is_typing = false
		next_indicator.visible = true
	else:
		# Pressionar Enter / clique após texto completo = avançar diálogo
		next_indicator.visible = false
		if current_dialogue_callback.is_valid():
			var cb = current_dialogue_callback
			current_dialogue_callback = Callable()
			cb.call()

# =========================================================================
# INTRODUÇÃO
# =========================================================================

func _start_intro() -> void:
	current_state = State.INTRO_DIALOGUE
	intro_index = 0
	_play_next_intro()

func _play_next_intro() -> void:
	if intro_index < intro_dialogue_ids.size():
		var id = intro_dialogue_ids[intro_index]
		var speaker = CSVDataManager.get_speaker(id)
		var text = CSVDataManager.get_dialogue_text(id)
		intro_index += 1
		_show_dialogue(speaker, text, _play_next_intro)
	else:
		# Fim do diálogo inicial -> liberar investigação e ocultar personagens
		_set_dialogue_visible(false)
		current_state = State.INVESTIGATION
		_set_speaker_focus("NONE")

# =========================================================================
# INVESTIGAÇÃO
# =========================================================================

func _on_investigate_object(obj_key: String) -> void:
	if current_state != State.INVESTIGATION:
		return
	if not room_objects.has(obj_key):
		return
	# Impede interagir com pistas já encontradas
	if collected_evidences.has(obj_key):
		return
	
	var obj = room_objects[obj_key]
	var csv_id = obj["csv_id"]
	var speaker = CSVDataManager.get_speaker(csv_id)
	var text = CSVDataManager.get_dialogue_text(csv_id)
	
	# Registrar evidência e desabilitar interação
	collected_evidences[obj_key] = obj
	_update_evidence_counter()
	_mark_object_inspected(obj_key)
	
	_show_dialogue(speaker, text, func():
		_set_dialogue_visible(false)
		_set_speaker_focus("NONE")
		# Verificar mínimo de 5 evidências
		if collected_evidences.size() == 5 and not min_evidences_notified:
			_trigger_min_evidence_dialogue()
	)

func _mark_object_inspected(obj_key: String) -> void:
	var btn = room_container.get_node_or_null("Obj_" + obj_key)
	if btn and btn is BaseButton:
		btn.disabled = true
		btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.mouse_default_cursor_shape = Control.CURSOR_ARROW
		var check = btn.get_node_or_null("StatusBadge")
		if check:
			check.text = "✓ COLETADO"
			check.modulate = Color(0.4, 0.9, 0.4, 0.8)

func _update_evidence_counter() -> void:
	var count = collected_evidences.size()
	evidence_counter_label.text = "EVIDÊNCIAS: %d/5 (Total: %d/9)" % [count, count]
	if count >= 5:
		evidence_counter_label.modulate = Color(0.95, 0.85, 0.3, 1.0)
		btn_proceed_analysis.visible = true

func _trigger_min_evidence_dialogue() -> void:
	min_evidences_notified = true
	var text = CSVDataManager.get_dialogue_text("I10")
	var speaker = CSVDataManager.get_speaker("I10")
	_show_dialogue(speaker, text, func():
		_set_dialogue_visible(false)
		_set_speaker_focus("NONE")
	)

# =========================================================================
# PAINEL DE EVIDÊNCIAS
# =========================================================================

var first_time_evidence_panel: bool = true

func _on_evidence_btn_pressed() -> void:
	evidence_panel.visible = true
	_refresh_evidence_grid()
	
	if first_time_evidence_panel:
		first_time_evidence_panel = false
		var text = CSVDataManager.get_dialogue_text("E01")
		var speaker = CSVDataManager.get_speaker("E01")
		_show_dialogue(speaker, text, func():
			_set_dialogue_visible(false)
			_set_speaker_focus("NONE")
		)

func _refresh_evidence_grid() -> void:
	for child in evidence_grid.get_children():
		child.queue_free()
	
	for key in collected_evidences.keys():
		var data = collected_evidences[key]
		var btn = Button.new()
		btn.text = data["name"]
		btn.custom_minimum_size = Vector2(130, 48)
		btn.pressed.connect(func(): _select_evidence(key))
		evidence_grid.add_child(btn)
	
	if collected_evidences.size() >= 5:
		btn_proceed_analysis.visible = true

func _select_evidence(key: String) -> void:
	selected_evidence_id = key
	var data = collected_evidences[key]
	evidence_detail_title.text = data["evidence_title"]
	evidence_detail_desc.text = data["evidence_desc"]
	
	var text = CSVDataManager.get_dialogue_text("E02")
	var speaker = CSVDataManager.get_speaker("E02")
	_show_dialogue(speaker, text, func():
		_set_dialogue_visible(false)
		_set_speaker_focus("NONE")
	)

func _on_proceed_to_analysis_pressed() -> void:
	evidence_panel.visible = false
	current_state = State.LARA_WEAK_ARGUMENT
	
	# Lara apresenta a proposição fraca (E03)
	var text = CSVDataManager.get_dialogue_text("E03")
	var speaker = CSVDataManager.get_speaker("E03")
	_show_dialogue(speaker, text, _trigger_objection)

# =========================================================================
# OBJEÇÃO!
# =========================================================================

func _trigger_objection() -> void:
	current_state = State.OBJECTION
	_set_dialogue_visible(false)
	
	# Efeito dramático de OBJEÇÃO
	objection_overlay.visible = true
	objection_banner.scale = Vector2(2.5, 2.5)
	flash_rect.visible = true
	flash_rect.color = Color(1, 1, 1, 1)
	
	# Flash e tremor
	var tween = create_tween().set_parallel(true)
	tween.tween_property(flash_rect, "color:a", 0.0, 0.3)
	tween.tween_property(objection_banner, "scale", Vector2(1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Screenshake sutil
	var shake_tween = create_tween()
	for i in range(5):
		shake_tween.tween_property(room_container, "position", Vector2(randf_range(-8, 8), randf_range(-8, 8)), 0.04)
	shake_tween.tween_property(room_container, "position", Vector2.ZERO, 0.05)
	
	tween.chain().tween_interval(0.8)
	tween.chain().tween_callback(_after_objection_fx)

func _after_objection_fx() -> void:
	objection_overlay.visible = false
	current_state = State.OBJECTION_EXPLANATION
	
	# Fala E05 do Mestre
	var text_e05 = CSVDataManager.get_dialogue_text("E05")
	var speaker_e05 = CSVDataManager.get_speaker("E05")
	_show_dialogue(speaker_e05, text_e05, func():
		# Fala E06 do Mestre
		var text_e06 = CSVDataManager.get_dialogue_text("E06")
		var speaker_e06 = CSVDataManager.get_speaker("E06")
		_show_dialogue(speaker_e06, text_e06, _start_logic_minigame)
	)

# =========================================================================
# MINIGAME LÓGICO
# =========================================================================

func _start_logic_minigame() -> void:
	current_state = State.LOGIC_MINIGAME
	_set_dialogue_visible(false)
	logic_panel.visible = true
	logic_step = 0
	_display_logic_step()

func _display_logic_step() -> void:
	logic_feedback_box.visible = false
	for child in logic_options_box.get_children():
		child.queue_free()
	
	var data = logic_questions[logic_step]
	logic_concept_label.text = data["concept"]
	logic_prompt_label.text = data["question"]
	
	for opt in data["options"]:
		var btn = Button.new()
		btn.text = opt["text"]
		btn.custom_minimum_size = Vector2(0, 52)
		btn.pressed.connect(func(): _on_select_logic_option(opt))
		logic_options_box.add_child(btn)

func _on_select_logic_option(option: Dictionary) -> void:
	logic_feedback_box.visible = true
	logic_feedback_label.text = option["feedback"]
	
	if option["correct"]:
		logic_feedback_label.modulate = Color(0.4, 0.95, 0.4, 1.0)
		logic_btn_next.visible = true
	else:
		logic_feedback_label.modulate = Color(0.95, 0.4, 0.4, 1.0)
		logic_btn_next.visible = false

func _on_logic_next_pressed() -> void:
	logic_step += 1
	if logic_step < logic_questions.size():
		_display_logic_step()
	else:
		logic_panel.visible = false
		_start_final_challenge()

# =========================================================================
# DESAFIO FINAL
# =========================================================================

func _start_final_challenge() -> void:
	current_state = State.FINAL_CHALLENGE
	
	# Fala F01 do Mestre
	var text_f01 = CSVDataManager.get_dialogue_text("F01")
	var speaker_f01 = CSVDataManager.get_speaker("F01")
	_show_dialogue(speaker_f01, text_f01, func():
		# Fala F02 de Lara apresentando a conclusão não sustentada
		var text_f02 = CSVDataManager.get_dialogue_text("F02")
		var speaker_f02 = CSVDataManager.get_speaker("F02")
		_show_dialogue(speaker_f02, text_f02, _display_final_decision)
	)

func _display_final_decision() -> void:
	_set_dialogue_visible(false)
	logic_panel.visible = true
	logic_feedback_box.visible = false
	for child in logic_options_box.get_children():
		child.queue_free()
	
	logic_concept_label.text = "DESAFIO FINAL: AVALIAÇÃO DE SUSTENTAÇÃO"
	logic_prompt_label.text = "Lara afirmou: 'A pessoa registrada pela câmera roubou o documento.'\nEssa afirmação é sustentada pelos fatos investigados?"
	
	var opts = [
		{
			"text": "NÃO é sustentada (Possibilidade ≠ Prova).",
			"correct": true,
			"feedback": "Correto! A câmera prova apenas a passagem de alguém, não o furto do documento!"
		},
		{
			"text": "SIM, a gravação comprova o roubo.",
			"correct": false,
			"feedback": "Incorreto! Presença física não equivale à autoria de um furto. Tente novamente."
		}
	]
	
	for opt in opts:
		var btn = Button.new()
		btn.text = opt["text"]
		btn.custom_minimum_size = Vector2(0, 52)
		btn.pressed.connect(func(): _on_select_final_challenge_option(opt))
		logic_options_box.add_child(btn)

func _on_select_final_challenge_option(option: Dictionary) -> void:
	logic_feedback_box.visible = true
	logic_feedback_label.text = option["feedback"]
	
	if option["correct"]:
		logic_feedback_label.modulate = Color(0.4, 0.95, 0.4, 1.0)
		logic_btn_next.visible = true
		logic_btn_next.pressed.disconnect(_on_logic_next_pressed)
		logic_btn_next.pressed.connect(_on_final_challenge_completed, CONNECT_ONE_SHOT)
	else:
		logic_feedback_label.modulate = Color(0.95, 0.4, 0.4, 1.0)
		logic_btn_next.visible = false

func _on_final_challenge_completed() -> void:
	logic_panel.visible = false
	
	# Fala F03
	var text_f03 = CSVDataManager.get_dialogue_text("F03")
	var speaker_f03 = CSVDataManager.get_speaker("F03")
	_show_dialogue(speaker_f03, text_f03, func():
		# Fala F04
		var text_f04 = CSVDataManager.get_dialogue_text("F04")
		var speaker_f04 = CSVDataManager.get_speaker("F04")
		_show_dialogue(speaker_f04, text_f04, func():
			# Fala F05
			var text_f05 = CSVDataManager.get_dialogue_text("F05")
			var speaker_f05 = CSVDataManager.get_speaker("F05")
			_show_dialogue(speaker_f05, text_f05, _show_tutorial_complete)
		)
	)

# =========================================================================
# CONCLUSÃO DO TUTORIAL
# =========================================================================

func _show_tutorial_complete() -> void:
	current_state = State.TUTORIAL_COMPLETE
	_set_dialogue_visible(false)
	complete_panel.visible = true
	
	# Atualizar o estado global
	GameState.complete_tutorial()

func _on_start_case01_pressed() -> void:
	# Retornar ao menu principal na aba de seleção de casos
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
