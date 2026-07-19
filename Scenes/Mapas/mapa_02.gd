extends Node2D
var placaDica2: bool = false;
var placaDica3: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dialogo("dicaMachadoRepetido")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_placa_dica_2_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDica2):
		await GameManager.dialogo("dicaCacadores")
		placaDica2 = true

func _on_placa_dica_3_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDica3):
		await GameManager.dialogo("dicaRepresa")
		placaDica3= true
