extends CharacterBody2D

@export var speed: float = 150.0 # Velocidade ajustada

# Pré-carrega a cena da bala para que possamos criar instâncias dela
@export var bullet_scene: PackedScene # Use @export para poder definir no editor!

func _physics_process(delta: float) -> void:
	# --- Código de Movimento (existente) ---
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()
	# --------------------------------------

	# --- Código de Ataque ---
	# Verifica se a ação 'attack_basic' foi pressionada NESTE frame
	if Input.is_action_just_pressed("attack_basic"):
		print("Ação 'attack_basic' detectada!") # <-- ADICIONE ESTA LINHA
		shoot() # Chama a função que criamos para atirar

func shoot() -> void:
	print("Função shoot() chamada.") # <-- ADICIONE ESTA LINHA

	# Verifica se a cena da bala foi definida no editor
	if not bullet_scene:
		print("ERRO: Cena da bala NÃO definida no Player!") # <-- Mensagem de erro
		return

	print("Cena da bala está definida:", bullet_scene) # <-- ADICIONE ESTA LINHA

	# Cria uma nova instância (cópia) da cena da bala
	var bullet_instance = bullet_scene.instantiate()
	print("Instância da bala criada:", bullet_instance) # <-- ADICIONE ESTA LINHA

	# Calcula a direção do jogador para o mouse
	var mouse_position = get_global_mouse_position()
	var shoot_direction = (mouse_position - global_position).normalized()
	print("Direção do tiro:", shoot_direction) # <-- ADICIONE ESTA LINHA

	# Define a posição inicial e direção da bala
	bullet_instance.global_position = global_position
	bullet_instance.direction = shoot_direction # Assume que bullet_instance tem a variável 'direction'

	# Adiciona a instância da bala à cena principal atual
	get_parent().add_child(bullet_instance)
	print("Bala adicionada como filha de:", get_parent().name) # <-- ADICIONE ESTA LINHA

	# (Opcional: Rotacionar o Player para olhar para o mouse ao atirar)
	# look_at(get_global_mouse_position())
