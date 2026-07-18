extends Area2D

@export var type: GameManager.PowerUpType
@onready var sprite = $Sprite2D
# Configurações da flutuação
@export var amplitude: float = 10.0  # Quantos pixels ele vai subir e descer
@export var velocidade: float = 3.0   # Quão rápido ele vai flutuar

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
		body.changePowerUp(type)
		queue_free()

func _physics_process(delta: float) -> void:
	# Acumula o tempo passado
	tempo += delta
	
	# Calcula o novo deslocamento vertical usando a função SENO
	var deslocamento_y = sin(tempo * velocidade) * amplitude
	
	# Aplica o movimento mantendo a posição X original intacta
	position.y = posicao_inicial.y + deslocamento_y
