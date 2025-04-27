extends CharacterBody2D

# ---- SINAL ----
# Sinal para avisar a UI quando a vida mudar
signal health_updated(new_health)

# ---- VARIÁVEIS ----
@export var speed: float = 150.0
@export var bullet_scene: PackedScene

# --- Variáveis de Vida ---
@export var max_health: int = 5 # Vida máxima (pode ajustar no Inspetor)
var current_health: int      # Vida atual

# ---- FUNÇÕES PADRÃO ----
func _ready() -> void:
	# Inicializa a vida atual com a máxima quando o player entra na cena
	current_health = max_health
	# Emite o sinal com a vida inicial para a UI atualizar
	health_updated.emit(current_health)
	# Adiciona o nó Player ao grupo "players" (importante para o inimigo encontrar!)
	# Faça isso aqui OU no editor (Nó > Grupos), mas garanta que esteja no grupo.
	if not is_in_group("players"):
		add_to_group("players")


func _physics_process(_delta: float) -> void:
	# --- Código de Movimento ---
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()

	# --- Código de Ataque ---
	if Input.is_action_just_pressed("attack_basic"):
		shoot()

# ---- FUNÇÕES ESPECÍFICAS ----
func shoot() -> void:
	if not bullet_scene:
		printerr("ERRO: Cena da bala não definida no Player!") # Use printerr para erros
		return
	var bullet_instance = bullet_scene.instantiate()
	var mouse_position = get_global_mouse_position()
	var shoot_direction = (mouse_position - global_position).normalized()
	bullet_instance.global_position = global_position # Ajuste se necessário (ex: + shoot_direction * 10)
	bullet_instance.direction = shoot_direction
	get_parent().add_child(bullet_instance)

# --- FUNÇÃO PARA RECEBER DANO ---
func take_damage(amount: int) -> void:
	current_health -= amount
	# Garante que a vida não fique abaixo de 0
	current_health = max(current_health, 0)
	# Avisa a UI e outros sistemas sobre a mudança na vida
	health_updated.emit(current_health)
	print("Player levou dano! Vida atual:", current_health) # Debug

	# AQUI: Adicione feedback visual/sonoro de dano no Player (ex: piscar sprite)
	# Exemplo simples de piscar:
	# $Sprite2D.modulate = Color.RED # Muda para vermelho
	# await get_tree().create_timer(0.1).timeout # Espera 0.1 segundos
	# $Sprite2D.modulate = Color.WHITE # Volta ao normal
	# (Isso requer que seu nó de sprite se chame "Sprite2D")

	# Verifica se o jogador morreu
	if current_health <= 0:
		die()

# --- FUNÇÃO DE MORTE ---
func die() -> void:
	print("Player Morreu!")
	# Ação de morte: Recarregar a cena, mostrar tela de game over, etc.
	# Exemplo: Recarregar a cena atual
	get_tree().reload_current_scene()
	# Exemplo: Pausar e talvez mostrar uma tela de Game Over depois
	# get_tree().paused = true
