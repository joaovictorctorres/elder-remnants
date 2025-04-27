extends CharacterBody2D


@export var health: int = 3
@export var move_speed: float = 100.0 # Velocidade de movimento do inimigo

# Variável para guardar a referência ao nó Player
var player: CharacterBody2D = null
# Flag para controlar o cooldown de dano
var can_damage: bool = true
# Referência ao Timer (usaremos @onready)
@onready var damage_cooldown_timer: Timer = $DamageCooldownTimer
# ... (resto do código: take_damage, die) ...
# Variável para a vida do inimigo, exportada para ajuste no editor

func _ready() -> void:
	# Tenta encontrar o nó Player pelo nome no nó pai (Main)
	player = get_parent().get_node_or_null("Player") # get_node_or_null evita erro se não encontrar

	if player == null:
		print("ERRO: Nó Player não encontrado para o inimigo!")
	# Tenta encontrar o nó Player na cena
	# Assumindo que o Player é um nó filho direto da cena principal (pai do inimigo)
	# Esta é uma forma simples, mas pode precisar de ajuste dependendo da estrutura da cena
	# player = get_parent().get_node("Player") # Se o Player for sempre chamado "Player"
	# Alternativa mais robusta: Encontrar por grupo (veremos depois)
	# Para testes, vamos assumir que ele consegue encontrar

	# Forma mais segura de encontrar o Player em estruturas mais complexas:
	# Percorrer a árvore ou usar grupos. Por enquanto, vamos simular que ele sabe onde o Player está para focar no movimento.
	# NO ENTANTO, para que a IA funcione, o 'player' PRECISA ser definido!
	# Vamos pegar a referência no script Main depois, ou usar grupos.
	# Por agora, o código de movimento assumirá que 'player' NÃO É null.
	pass # Remove o 'pass' quando tiver a linha que encontra o player

# Esta função é chamada a cada frame de física para o movimento
func _physics_process(_delta: float) -> void:
	# Só tenta mover se o player existir
	if player:
		# 1. Calcula o vetor direção do inimigo para o player
		# (Posição do player - Posição do inimigo). Normaliza para obter apenas a direção.
		var direction_to_player = (player.global_position - global_position).normalized()

		# 2. Define a velocidade do inimigo
		velocity = direction_to_player * move_speed

		# 3. Move o inimigo e lida com colisões
		move_and_slide()

		# Opcional: Rotacionar o inimigo para olhar para o player (se a arte exigir)
		# look_at(player.global_position)
	else:
		# Se o player não for encontrado (ainda!), o inimigo fica parado
		velocity = Vector2.ZERO

# Esta função será chamada pela bala quando o inimigo for atingido
func take_damage(amount: int) -> void:
	health -= amount
	print("Inimigo atingido! Vida restante:", health) # Mensagem de debug

	# Adicionar feedback visual aqui depois (piscar, etc.)

	if health <= 0:
		die()

# Função para quando o inimigo morrer
func die() -> void:
	print("Inimigo derrotado!")
	queue_free() # Remove o inimigo da cena
# ... (topo do script, _ready, _physics_process, take_damage, die) ...

# Chamada quando um corpo entra na Hitbox Area2D
func _on_hitbox_body_entered(body: Node2D) -> void:

	print("HITBOX DETECTOU:", body.name) # <-- Adicione esta linha
	
	# Verifica se o corpo é do grupo "players" E se o inimigo pode causar dano agora
	if body.is_in_group("players") and can_damage:
		print("Inimigo atingiu o Player:", body.name) # Debug

		# Chama a função take_damage no corpo (Player)
		# Você pode definir o valor do dano aqui (ex: 1)
		body.take_damage(1)

		# Impede dano imediato novamente
		can_damage = false
		# Inicia o timer de cooldown
		damage_cooldown_timer.start()

# Chamada quando o DamageCooldownTimer termina
func _on_damage_cooldown_timer_timeout() -> void:
	# Permite que o inimigo cause dano novamente
	can_damage = true
	print("Inimigo pode causar dano novamente.") # Debug
