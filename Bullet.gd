extends Area2D

# Velocidade da bala em pixels por segundo
@export var speed: float = 600.0
# Direção normalizada em que a bala vai se mover (será definida pelo Player)
var direction: Vector2 = Vector2.ZERO

# Duração da bala em segundos antes de desaparecer
@export var lifetime: float = 2.0

# Timer interno para controlar a vida útil
var lifetime_timer: Timer

func _ready() -> void:
	# Cria um Timer via código quando a bala entra na cena
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true # Dispara apenas uma vez
	# Conecta o sinal 'timeout' do timer à função '_on_lifetime_timeout' deste script
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	# Adiciona o timer como filho da bala para que ele funcione
	add_child(lifetime_timer)
	# Inicia o timer
	lifetime_timer.start()

	# Rotaciona o sprite para apontar na direção do movimento
	# (Ajuste 'rotation = direction.angle()' se seu sprite padrão aponta para a direita)
	rotation = direction.angle() + deg_to_rad(90) # Ajuste +90 se seu sprite padrão aponta para cima


func _physics_process(delta: float) -> void:
	# Move a bala na direção definida com a velocidade definida
	# Usamos global_position para ter certeza que estamos no sistema de coordenadas do mundo
	global_position += direction * speed * delta

# Função chamada quando o Timer de vida útil termina
func _on_lifetime_timeout() -> void:
	queue_free() # Remove a bala da cena

# (Opcional, mas útil para o futuro: detectar acertos)
# Conecte o sinal 'body_entered' do Area2D (no editor, aba Nó) a esta função
# func _on_body_entered(body: Node) -> void:
# 	print("Bala atingiu:", body.name)
# 	if body.has_method("take_damage"): # Verifica se o corpo atingido é um inimigo (por exemplo)
# 		body.take_damage(1) # Causa dano (você precisará criar essa função no inimigo)
# 	queue_free() # Bala se destrói ao atingir algo
# ... (resto do código do bullet.gd: extends, exports, _ready, _physics_process, _on_lifetime_timeout) ...


# Função conectada ao sinal 'body_entered' do Area2D
func _on_body_entered(body: Node2D) -> void:
	# 'body' é o nó que entrou na área da bala

	# ---- NOVO: Ignorar o Player ----
	# Se o corpo que entrou está no grupo "players", não faça nada e saia da função.
	if body.is_in_group("players"):
		return # Sai da função, ignorando o Player

	# ---- Lógica Original (agora só roda se NÃO for o Player) ----
	# Verifica se o corpo que entrou TEM o método 'take_damage' (será o Inimigo)
	if body.has_method("take_damage"):
		print("Bala atingiu um corpo com 'take_damage':", body.name) # Debug
		# Chama a função take_damage no corpo atingido, passando 1 de dano
		body.take_damage(1)
		# Destroi a bala após atingir um alvo válido (Inimigo)
		queue_free()

	# Opcional: Destruir a bala se atingir uma parede (requer TileMap com colisão)
	# elif body is TileMap: # Ou verificar por grupo ("parede")
	#    queue_free()
