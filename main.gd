extends Node2D

# Função chamada uma vez que a cena Main está pronta
func _ready() -> void:
	# Encontra o primeiro nó no grupo "players"
	# get_tree().get_nodes_in_group("players") retorna um array
	var players_in_scene = get_tree().get_nodes_in_group("players")

	var main_player = null
	if players_in_scene.size() > 0:
		main_player = players_in_scene[0] # Assume que o primeiro player encontrado é O player principal
	else:
		print("ERRO: Nenhum nó no grupo 'players' encontrado na cena Main!")
		return # Não continue se não houver player

	# Encontra todos os inimigos na cena (assumindo que estão no grupo "enemies" - vamos adicionar isso!)
	var enemies_in_scene = get_tree().get_nodes_in_group("enemies") # PRECISA ADICIONAR INIMIGOS AO GRUPO "enemies"!

		# Itera sobre cada inimigo encontrado e atribui a referência do player a ele
	for enemy in enemies_in_scene:
		if enemy.has_node("Player"): # <--- Linha 21 (ou próxima a ela)
			enemy.player = main_player # Atribui a referência

# Precisamos adicionar os inimigos ao grupo "enemies" agora!
