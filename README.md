# ⚖️ Tribunal Lógico

> **"Investigue. Argumente. Conclua."**

**Tribunal Lógico** é um jogo sério (*serious game*) no gênero **Visual Novel + Investigação + Puzzle Lógico**, inspirado na consagrada franquia *Phoenix Wright: Ace Attorney*.

O projeto foi desenvolvido para transformar o aprendizado de **Raciocínio Lógico Formal e Argumentativo** em uma experiência investigativa engajante, dinâmica e intuitiva.

---

## 🎯 Objetivo Pedagógico

O objetivo pedagógico central é ensinar fundamentos da lógica através da resolução de mistérios e análise de contradições em depoimentos e evidências:

- **Diferenciação Fundamental:** Evidência ≠ Conclusão e Possibilidade ≠ Prova.
- **Proposições Lógicas:** O que caracteriza uma declaração com valor-verdade bem definido.
- **Valores-Verdade:** Verdadeiro ($V$) e Falso ($F$).
- **Negação Lógica ($\neg P$ / NÃO):** Compreensão do oposto lógico de uma proposição.
- **Conjunção ($\land$ / E):** Condições de verdade quando múltiplas premissas são exigidas simultaneamente.
- **Disjunção ($\lor$ / OU):** Alternativas lógicas e suas aplicações em deduções.
- **Implicação / Condicional ($\rightarrow$ / SE... ENTÃO):** Causa e efeito lógicos, validade de inferências e falácias de afirmação do consequente.

---

## 👥 Personagens

| Personagem | Papel | Características |
| :--- | :--- | :--- |
| **Advogado** | Mentor / Protagonista | Experiente, observador e rigoroso. Não entrega as respostas prontas: guia através de perguntas provocativas e exige que intuições sejam sustentadas por evidências concretas. Famoso por seu comando de **"OBJEÇÃO!"**. |
| **Lara** | Advogada em Treinamento | Recém-formada, perspicaz, confiante e com excelente capacidade de observação visual, porém ainda precipitada ao conectar indícios a conclusões definitivas. Evolui ao longo das investigações. |

---

## 🕹️ Funcionalidades & Fluxo de Jogo

1. **Menu Principal & Seleção de Casos:**
   - Interface limpa com transições fluidas via *Tweens*.
   - Seleção de Casos com cartas de casos bloqueadas e destaque interativo com cadeado no **Tutorial**.
2. **Transição Cinematográfica:**
   - Tela de *Loading* customizada com barra de progresso dourada sobre fundo estilizado.
3. **Cena de Investigação (Tutorial):**
   - Cenário imersivo em pixel art com **9 pontos interativos (hotspots)**: Mesa, Gaveta, Relógio, Porta, Janela, Lixeira, Computador, Estante e Câmera.
   - Pistas investigadas desativam sua interação para evitar repetições desnecessárias.
4. **Painel de Evidências:**
   - Inventário dinâmico com inspeção de detalhes e exigência de quantidade mínima (5 evidências) para prosseguir.
5. **Sistema de Diálogo Avançado:**
   - Texto progressivo (*typewriter effect*).
   - Suporte a teclado: pressione <kbd>Enter</kbd> para acelerar/completar o texto e novamente para avançar.
   - Sprites expressivos posicionados à frente do diálogo, com exibição e ocultação dinâmica.
6. **Momento "OBJEÇÃO!":**
   - Banner dramático de interrupção com impacto visual e feedback quando Lara apresenta um argumento fraco.
7. **Minigame de Decisões Lógicas:**
   - Desafios de múltipla escolha para validar conceitos de lógica proposicional e aplicação ao caso investigado.
8. **Desbloqueio de Casos:**
   - Conclusão do Tutorial registra o progresso no singleton global `GameState`, liberando o **Caso 01**.

---

## 🛠️ Tecnologias Utilizadas

- **Engine:** [Godot Engine 4.x](https://godotengine.org/) (GDScript 2.0).
- **Estruturação de Dados:** `CSV` para falas e gatilhos de interação com sistema de *fallback* embutido resiliente para builds exportadas.
- **Design & UI:** Node tree modular, CanvasLayer, RichTextLabel, Tweens e TextureButtons.

---

## 📁 Estrutura do Projeto

```text
tribunal-logico/
├── artwork/
│   ├── characters/        # Sprites do Advogado e da Lara (expressões e poses)
│   ├── scenes/            # Cenários de fundo (ex: scene-tutorial.png)
│   └── ui/                # Botões, banners, molduras, logo, cadeados e ícones
├── scenes/
│   ├── main_menu.tscn     # Menu inicial e seleção de episódios
│   ├── loading_screen.tscn# Tela de carregamento
│   └── tutorial_scene.tscn# Cena principal do tutorial e investigação
├── scripts/
│   ├── game_state.gd      # Singleton autoload para persistência e progresso
│   ├── main_menu.gd       # Controlador da interface do menu
│   ├── loading_screen.gd  # Controlador da barra de progresso
│   ├── tutorial_controller.gd # Máquina de estados do tutorial e diálogos
│   └── csv_data_manager.gd# Parser de CSV com fallback seguro para builds
├── TRIBUNAL_LOGICO_TUTORIAL_FALAS_INTERACOES.csv # Roteiro oficial de diálogos
├── export_presets.cfg     # Presets de exportação com suporte a arquivos de dados
└── project.godot          # Configurações do projeto Godot
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- **Godot Engine 4.x** (Standard Edition).

### Executando no Editor
1. Clone este repositório:
   ```bash
   git clone https://github.com/Germano123/aqueleprof-tribunal-logico.git
   ```
2. Abra o **Godot Engine** e clique em **Import** (Importar).
3. Selecione o arquivo `project.godot` na pasta raiz do repositório.
4. Pressione <kbd>F5</kbd> (ou clique no botão **Play** no canto superior direito) para iniciar o jogo a partir do Menu Principal (`res://scenes/main_menu.tscn`).

---

## 📜 Licença

Projeto desenvolvido com fins educacionais para a plataforma **Aquele Prof**. Todos os direitos reservados.
