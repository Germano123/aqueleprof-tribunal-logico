# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [0.1.0] - 2026-11-09

### Adicionado
- **Menu Principal e Seleção de Casos:**
  - Tela inicial com logo oficial, sprite do Advogado e botões centralizados (Modo História, Opções, Sair).
  - Transição animada da tela inicial para a seleção de casos através de `Tween`.
  - Exibição dos cards dos Casos 01, 02 e 03 bloqueados.
  - Botão de acesso ao Tutorial com ícone animado de cadeado saltando.
- **Tela de Carregamento (Loading Screen):**
  - Transição com *fade-in* e *fade-out*.
  - Barra de progresso com preenchimento dourado dinâmico.
- **Tutorial Interativo Jogável:**
  - Cenário de fundo da sala de treinamento (`scene-tutorial.png`).
  - 9 hotspots de investigação interativos (Mesa, Gaveta, Relógio, Porta, Janela, Lixeira, Computador, Estante, Câmera).
  - Controle de quantidade mínima de evidências (5 necessárias para avançar).
  - Painel de Evidências com inspeção de detalhes e inventário persistente durante a cena.
  - Efeito dramático de "OBJEÇÃO!" com banner animado e flash.
  - Minigame lógico com perguntas de múltipla escolha abordando: Proposições, V/F, Negação, Conjunção (E), Disjunção (OU) e Implicação (SE... ENTÃO).
  - Desafio final e tela de conclusão com desbloqueio do Caso 01.
- **Sistema de Diálogos:**
  - Efeito máquina de escrever (*typewriter*) com avanço progressivo de caracteres.
  - Suporte ao teclado via tecla <kbd>Enter</kbd> (acelera o texto ou avança a fala).
  - Sprites expressivos de Lara (à direita) e do Advogado (à esquerda) posicionados em primeiro plano.
- **Arquitetura & Dados:**
  - Parser de CSV (`CsvDataManager`) lendo falas e gatilhos diretamente de `TRIBUNAL_LOGICO_TUTORIAL_FALAS_INTERACOES.csv`.
  - Mecanismo de dados embutidos (`EMBEDDED_DATA`) como *fallback* de segurança para garantir a execução correta em compilações standalone exportadas.
  - Singleton autoload `GameState` para controle global de progresso entre cenas.

### Modificado
- Interface da caixa de diálogo ajustada para melhor proporção e leitura.
- Aumentado o tamanho da fonte dos diálogos para maior acessibilidade.
- Sprites dos personagens reposicionados para sobrepor a barra de diálogo, ocultando-se automaticamente quando o diálogo é encerrado.
- Desativação dos hotspots de investigação logo após a respectiva pista ser encontrada, evitando reinterações duplicadas.

### Corrigido
- Falha no carregamento de diálogos em builds exportadas para PCK standalone provocada pela conversão padrão de `.csv` do Godot para arquivos `.translation`. O arquivo agora é importado como arquivo bruto e protegido por *fallback* embutido no GDScript.
- Configuração do `.gitignore` atualizada para excluir diretório de `builds/` e pacotes binários grandes (>100MB), prevenindo rejeição de push no GitHub.
