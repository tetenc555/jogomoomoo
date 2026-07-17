func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player": # Verificar qual o nome do player
		# Adicionar aqui oq acontece caso o player pegue o item 
		# player.mode(axe)
		# player.mode(shotgun)
		# player.add_points()
		# Apagar o item do jogo
		queue_free()
