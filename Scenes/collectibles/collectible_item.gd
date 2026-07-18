extends Area2D

@export var type: GameManager.PowerUpType
@onready var sprite = $Sprite2D
# Configurações da flutuação
@export var amplitude: float = 10.0  # Quantos pixels ele vai subir e descer
@export var velocidade: float = 3.0   # Quão rápido ele vai flutuar
var pode_flutuar:bool = true
# Guarda a posição inicial para o item não sair flutuando pelo mapa
var posicao_inicial: Vector2
var tempo: float = 0.0

func _ready() -> void:
	# Guarda onde o item foi colocado no mapa
	posicao_inicial = position
	match type:
		GameManager.PowerUpType.ARMA:
			sprite.texture = preload("res://Assets/fourSeasonsPlatformer_ [tileset, version 2.0]/Collectibles/shotgun.png")
		GameManager.PowerUpType.MACHADO:
			sprite.texture = preload("res://Assets/fourSeasonsPlatformer_ [tileset, version 2.0]/Collectibles/axe.png")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Apagar o item do jogo
		if body.changePowerUp(type):
			queue_free()

func _physics_process(delta: float) -> void:
	# Acumula o tempo passado
	tempo += delta
	
	# Calcula o novo deslocamento vertical usando a função SENO
	var deslocamento_y = sin(tempo * velocidade) * amplitude
	
	# Aplica o movimento mantendo a posição X original intacta
	position.y = posicao_inicial.y + deslocamento_y

func aplicar_impulso_drop(direcao: float):
	monitoring = false
	monitorable = false
	pode_flutuar = false 
	
	# 1. Altere a distância aqui para o item não ir tão longe para o lado
	var destino_horizontal = global_position.x + (direcao * 16) # Antes era 32
	
	# 2. Altere a altura aqui para ele não pular tão alto
	var altura_arco = global_position.y - 8 # Antes era 16 
	var destino_vertical = global_position.y - 20
	
	var tween = create_tween()
	
	# 3. Aumente o tempo (ex: de 0.2 para 0.4) para o movimento ficar mais lento e suave
	var tempo_subida = 0.2
	var tempo_descida = 0.2
	
	# Passo A: Subida
	tween.set_parallel(true)
	tween.tween_property(self, "global_position:x", global_position.x + (direcao * 8), tempo_subida).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position:y", altura_arco, tempo_subida).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Passo B: Descida
	tween.chain().set_parallel(true)
	tween.tween_property(self, "global_position:x", destino_horizontal, tempo_descida).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position:y", destino_vertical, tempo_descida).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	posicao_inicial = position 
	pode_flutuar = true
	monitoring = true
	monitorable = true
