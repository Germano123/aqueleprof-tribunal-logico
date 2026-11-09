class_name CSVDataManager
extends RefCounted

static var _entries: Dictionary = {}
static var _is_loaded: bool = false

const EMBEDDED_DATA: Dictionary = {
	"T00": {
		"id": "T00",
		"elemento": "SISTEMA",
		"tipo": "LOAD",
		"gatilho": "Ao clicar em TUTORIAL na seleção de fases.",
		"fala_original": "Executar fade out, carregar a cena do tutorial e exibir loading screen com loadingbar-progress-bg e progresso dourado de 0% a 100%.",
		"speaker": "SISTEMA",
		"fala": "Executar fade out, carregar a cena do tutorial e exibir loading screen com loadingbar-progress-bg e progresso dourado de 0% a 100%.",
		"acao": "Após 100%, executar fade in da cena do tutorial.",
	},
	"T01": {
		"id": "T01",
		"elemento": "MESTRE",
		"tipo": "DIALOGUE",
		"gatilho": "Cena carregada.",
		"fala_original": "MESTRE: \"Lara, antes de aprender a argumentar, você precisa aprender a investigar.\"",
		"speaker": "MESTRE",
		"fala": "Lara, antes de aprender a argumentar, você precisa aprender a investigar.",
		"acao": "Abrir diálogo inicial.",
	},
	"T02": {
		"id": "T02",
		"elemento": "LARA",
		"tipo": "DIALOGUE",
		"gatilho": "Após fala do Mestre.",
		"fala_original": "LARA: \"Investigar? Achei que você fosse me ensinar a encontrar o culpado.\"",
		"speaker": "LARA",
		"fala": "Investigar? Achei que você fosse me ensinar a encontrar o culpado.",
		"acao": "Avançar diálogo.",
	},
	"T03": {
		"id": "T03",
		"elemento": "MESTRE",
		"tipo": "DIALOGUE",
		"gatilho": "Após fala de Lara.",
		"fala_original": "MESTRE: \"Encontrar um culpado é fácil. Difícil é provar que sua conclusão está correta.\"",
		"speaker": "MESTRE",
		"fala": "Encontrar um culpado é fácil. Difícil é provar que sua conclusão está correta.",
		"acao": "Encerrar diálogo e liberar exploração.",
	},
	"I01": {
		"id": "I01",
		"elemento": "MESA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na mesa.",
		"fala_original": "LARA: \"Os documentos estão fora do lugar.\"",
		"speaker": "LARA",
		"fala": "Os documentos estão fora do lugar.",
		"acao": "Registrar inspeção e adicionar evidência dos documentos.",
	},
	"I02": {
		"id": "I02",
		"elemento": "GAVETA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na gaveta.",
		"fala_original": "LARA: \"Uma gaveta aberta... vamos ver o que há aqui.\"",
		"speaker": "LARA",
		"fala": "Uma gaveta aberta... vamos ver o que há aqui.",
		"acao": "Revelar a chave e adicionar evidência.",
	},
	"I03": {
		"id": "I03",
		"elemento": "RELOGIO",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar no relógio.",
		"fala_original": "LARA: \"O relógio está parado às 18h32.\"",
		"speaker": "LARA",
		"fala": "O relógio está parado às 18h32.",
		"acao": "Registrar horário como evidência.",
	},
	"I04": {
		"id": "I04",
		"elemento": "PORTA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na porta.",
		"fala_original": "MESTRE: \"Não olhe apenas para a porta. Procure o que ela pode nos dizer.\"",
		"speaker": "MESTRE",
		"fala": "Não olhe apenas para a porta. Procure o que ela pode nos dizer.",
		"acao": "Adicionar evidência do registro de abertura.",
	},
	"I05": {
		"id": "I05",
		"elemento": "JANELA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na janela.",
		"fala_original": "LARA: \"A janela está fechada. Então essa passagem parece improvável.\"",
		"speaker": "LARA",
		"fala": "A janela está fechada. Então essa passagem parece improvável.",
		"acao": "Registrar estado da janela como evidência.",
	},
	"I06": {
		"id": "I06",
		"elemento": "LIXEIRA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar no cesto de lixo.",
		"fala_original": "MESTRE: \"Você está procurando direito? Não parece ter nada relevante aí.\"",
		"speaker": "MESTRE",
		"fala": "Você está procurando direito? Não parece ter nada relevante aí.",
		"acao": "Permitir inspeção e revelar fragmento de papel; adicionar evidência.",
	},
	"I07": {
		"id": "I07",
		"elemento": "COMPUTADOR",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar no computador.",
		"fala_original": "LARA: \"O computador foi usado recentemente.\"",
		"speaker": "LARA",
		"fala": "O computador foi usado recentemente.",
		"acao": "Adicionar evidência do último acesso.",
	},
	"I08": {
		"id": "I08",
		"elemento": "ESTANTE",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na estante.",
		"fala_original": "LARA: \"Este livro está fora do lugar... alguém mexeu aqui.\"",
		"speaker": "LARA",
		"fala": "Este livro está fora do lugar... alguém mexeu aqui.",
		"acao": "Registrar livro deslocado como evidência secundária.",
	},
	"I09": {
		"id": "I09",
		"elemento": "CAMERA",
		"tipo": "INVESTIGATION",
		"gatilho": "Ao clicar na câmera.",
		"fala_original": "MESTRE: \"Agora sim. Uma câmera pode dizer muito mais do que uma impressão.\"",
		"speaker": "MESTRE",
		"fala": "Agora sim. Uma câmera pode dizer muito mais do que uma impressão.",
		"acao": "Adicionar evidência de gravação disponível.",
	},
	"I10": {
		"id": "I10",
		"elemento": "EVIDENCE_MIN",
		"tipo": "SYSTEM",
		"gatilho": "Ao coletar a quinta evidência relevante.",
		"fala_original": "MESTRE: \"Já temos material suficiente para começar a analisar. Mas, se quiser, continue procurando.\"",
		"speaker": "MESTRE",
		"fala": "Já temos material suficiente para começar a analisar. Mas, se quiser, continue procurando.",
		"acao": "Marcar investigação mínima atingida; manter exploração.",
	},
	"E01": {
		"id": "E01",
		"elemento": "EVIDENCIAS",
		"tipo": "TUTORIAL",
		"gatilho": "Primeiro clique no botão EVIDÊNCIAS.",
		"fala_original": "MESTRE: \"Encontrar uma pista não basta. Agora precisamos descobrir o que ela realmente demonstra.\"",
		"speaker": "MESTRE",
		"fala": "Encontrar uma pista não basta. Agora precisamos descobrir o que ela realmente demonstra.",
		"acao": "Abrir painel e destacar primeiro item.",
	},
	"E02": {
		"id": "E02",
		"elemento": "EVIDENCIAS",
		"tipo": "ANALYSIS",
		"gatilho": "Selecionar uma evidência.",
		"fala_original": "LARA: \"Então é isso que temos de concreto.\"",
		"speaker": "LARA",
		"fala": "Então é isso que temos de concreto.",
		"acao": "Exibir descrição completa da evidência.",
	},
	"E03": {
		"id": "E03",
		"elemento": "PROPOSICAO",
		"tipo": "DIALOGUE",
		"gatilho": "Após análise inicial.",
		"fala_original": "LARA: \"A porta foi aberta às 18h31. Então quem abriu a porta roubou o documento.\"",
		"speaker": "LARA",
		"fala": "A porta foi aberta às 18h31. Então quem abriu a porta roubou o documento.",
		"acao": "Apresentar a afirmação no minigame.",
	},
	"E04": {
		"id": "E04",
		"elemento": "OBJECAO",
		"tipo": "LOGIC",
		"gatilho": "Confirmar conclusão sem evidência suficiente.",
		"fala_original": "MESTRE: \"OBJEÇÃO!\"",
		"speaker": "MESTRE",
		"fala": "OBJEÇÃO!",
		"acao": "Executar efeito de objeção e iniciar correção.",
	},
	"E05": {
		"id": "E05",
		"elemento": "OBJECAO",
		"tipo": "DIALOGUE",
		"gatilho": "Após objeção.",
		"fala_original": "MESTRE: \"A evidência prova que a porta foi aberta. Ela não prova quem abriu, nem que houve um roubo naquele momento.\"",
		"speaker": "MESTRE",
		"fala": "A evidência prova que a porta foi aberta. Ela não prova quem abriu, nem que houve um roubo naquele momento.",
		"acao": "Marcar argumento como não sustentado.",
	},
	"E06": {
		"id": "E06",
		"elemento": "ARGUMENTO",
		"tipo": "LOGIC",
		"gatilho": "Após explicação.",
		"fala_original": "MESTRE: \"Uma boa hipótese pode apontar o caminho. Uma boa conclusão precisa estar apoiada nos fatos.\"",
		"speaker": "MESTRE",
		"fala": "Uma boa hipótese pode apontar o caminho. Uma boa conclusão precisa estar apoiada nos fatos.",
		"acao": "Liberar minigame de reforço da proposição.",
	},
	"L01": {
		"id": "L01",
		"elemento": "VERDADEIRO_FALSO",
		"tipo": "LOGIC",
		"gatilho": "Primeira decisão lógica.",
		"fala_original": "MESTRE: \"A porta foi aberta às 18h31. Isso é verdadeiro ou falso?\"",
		"speaker": "MESTRE",
		"fala": "A porta foi aberta às 18h31. Isso é verdadeiro ou falso?",
		"acao": "Jogador seleciona VERDADEIRO ou FALSO.",
	},
	"L02": {
		"id": "L02",
		"elemento": "NEGACAO",
		"tipo": "LOGIC",
		"gatilho": "Após V/F.",
		"fala_original": "MESTRE: \"Agora negue a afirmação. Se a porta foi aberta às 18h31, qual seria a sua negação?\"",
		"speaker": "MESTRE",
		"fala": "Agora negue a afirmação. Se a porta foi aberta às 18h31, qual seria a sua negação?",
		"acao": "Apresentar proposição e negação como decisão.",
	},
	"L03": {
		"id": "L03",
		"elemento": "E",
		"tipo": "LOGIC",
		"gatilho": "Após negação.",
		"fala_original": "MESTRE: \"Quando usamos E, as duas afirmações precisam ser verdadeiras.\"",
		"speaker": "MESTRE",
		"fala": "Quando usamos E, as duas afirmações precisam ser verdadeiras.",
		"acao": "Executar minigame com operador E.",
	},
	"L04": {
		"id": "L04",
		"elemento": "OU",
		"tipo": "LOGIC",
		"gatilho": "Após E.",
		"fala_original": "MESTRE: \"Com OU, basta uma das possibilidades ser verdadeira para a afirmação composta ser verdadeira.\"",
		"speaker": "MESTRE",
		"fala": "Com OU, basta uma das possibilidades ser verdadeira para a afirmação composta ser verdadeira.",
		"acao": "Executar minigame com operador OU.",
	},
	"L05": {
		"id": "L05",
		"elemento": "SE_ENTAO",
		"tipo": "LOGIC",
		"gatilho": "Após OU.",
		"fala_original": "MESTRE: \"Agora vamos relacionar uma condição a uma consequência: SE uma condição acontece, ENTÃO esperamos determinado resultado.\"",
		"speaker": "MESTRE",
		"fala": "Agora vamos relacionar uma condição a uma consequência: SE uma condição acontece, ENTÃO esperamos determinado resultado.",
		"acao": "Executar minigame introdutório de SE...ENTÃO.",
	},
	"F01": {
		"id": "F01",
		"elemento": "DESAFIO_FINAL",
		"tipo": "LOGIC",
		"gatilho": "Após os conceitos básicos.",
		"fala_original": "MESTRE: \"Agora é com você. Analise os fatos e diga apenas aquilo que eles permitem concluir.\"",
		"speaker": "MESTRE",
		"fala": "Agora é com você. Analise os fatos e diga apenas aquilo que eles permitem concluir.",
		"acao": "Iniciar desafio final.",
	},
	"F02": {
		"id": "F02",
		"elemento": "DESAFIO_FINAL",
		"tipo": "LOGIC",
		"gatilho": "Apresentar conclusão não sustentada.",
		"fala_original": "LARA: \"A pessoa registrada pela câmera roubou o documento.\"",
		"speaker": "LARA",
		"fala": "A pessoa registrada pela câmera roubou o documento.",
		"acao": "Exigir identificação de afirmação não sustentada.",
	},
	"F03": {
		"id": "F03",
		"elemento": "DESAFIO_FINAL",
		"tipo": "DIALOGUE",
		"gatilho": "Após resposta correta.",
		"fala_original": "MESTRE: \"Exatamente. Você encontrou uma possibilidade, mas não confundiu possibilidade com prova.\"",
		"speaker": "MESTRE",
		"fala": "Exatamente. Você encontrou uma possibilidade, mas não confundiu possibilidade com prova.",
		"acao": "Prosseguir para encerramento.",
	},
	"F04": {
		"id": "F04",
		"elemento": "FINAL",
		"tipo": "DIALOGUE",
		"gatilho": "Após desafio.",
		"fala_original": "LARA: \"Então investigar não é procurar uma resposta. É descobrir quais respostas os fatos permitem.\"",
		"speaker": "LARA",
		"fala": "Então investigar não é procurar uma resposta. É descobrir quais respostas os fatos permitem.",
		"acao": "Exibir conclusão.",
	},
	"F05": {
		"id": "F05",
		"elemento": "FINAL",
		"tipo": "DIALOGUE",
		"gatilho": "Após fala de Lara.",
		"fala_original": "MESTRE: \"Agora você está começando a entender.\"",
		"speaker": "MESTRE",
		"fala": "Agora você está começando a entender.",
		"acao": "Marcar tutorial como concluído.",
	},
	"F06": {
		"id": "F06",
		"elemento": "FINAL",
		"tipo": "SYSTEM",
		"gatilho": "Tutorial concluído.",
		"fala_original": "Exibir TUTORIAL CONCLUÍDO e botão COMEÇAR CASO 01.",
		"speaker": "SISTEMA",
		"fala": "Exibir TUTORIAL CONCLUÍDO e botão COMEÇAR CASO 01.",
		"acao": "Liberar Caso 01.",
	},
}

static func load_csv(path: String = "res://TRIBUNAL_LOGICO_TUTORIAL_FALAS_INTERACOES.csv") -> void:
	if _is_loaded:
		return
	
	# Tentar ler o arquivo CSV caso esteja presente no sistema de arquivos ou pacote
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			# Ler cabeçalho
			var _header = file.get_csv_line()
			
			while not file.eof_reached():
				var line = file.get_csv_line()
				if line.size() < 6:
					continue
				var id = line[0].strip_edges().trim_prefix("\ufeff")
				if id.is_empty():
					continue
				
				var raw_fala = line[4].strip_edges()
				var speaker = line[1].strip_edges()
				var clean_fala = raw_fala
				
				if ":" in raw_fala:
					var parts = raw_fala.split(":", true, 1)
					if parts.size() > 1:
						var potential_speaker = parts[0].strip_edges()
						if potential_speaker in ["MESTRE", "LARA", "SISTEMA"]:
							speaker = potential_speaker
							clean_fala = parts[1].strip_edges()
							if clean_fala.begins_with("\"") and clean_fala.ends_with("\""):
								clean_fala = clean_fala.substr(1, clean_fala.length() - 2).strip_edges()
				
				_entries[id] = {
					"id": id,
					"elemento": line[1].strip_edges(),
					"tipo": line[2].strip_edges(),
					"gatilho": line[3].strip_edges(),
					"fala_original": raw_fala,
					"speaker": speaker,
					"fala": clean_fala,
					"acao": line[5].strip_edges()
				}
			
			if not _entries.is_empty():
				_is_loaded = true
				return
	
	# Fallback garantido para builds exportadas caso o arquivo bruto CSV não seja empacotado
	_entries = EMBEDDED_DATA.duplicate(true)
	_is_loaded = true

static func get_entry(id: String) -> Dictionary:
	if not _is_loaded:
		load_csv()
	return _entries.get(id, {})

static func get_dialogue_text(id: String) -> String:
	var entry = get_entry(id)
	return entry.get("fala", "")

static func get_speaker(id: String) -> String:
	var entry = get_entry(id)
	return entry.get("speaker", "MESTRE")

static func get_action(id: String) -> String:
	var entry = get_entry(id)
	return entry.get("acao", "")
