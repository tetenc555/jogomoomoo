extends Node2D

var placaDicaMachadoPlayed: bool = false;
var placaDica2: bool = false;
var placaDica3: bool = false;
var placaDica4: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dialogo("historiaMapa01")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_placa_dica_machado_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDicaMachadoPlayed):
		await GameManager.dialogo("dicaMachado")
		placaDicaMachadoPlayed = true


func _on_placa_dica_2_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDica2):
		await GameManager.dialogo("dicaPlaca2")
		placaDica2 = true


func _on_placa_dica_3_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDica3):
		await GameManager.dialogo("dicaMachado")
		placaDica3= true


func _on_placa_dica_4_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") and !placaDica4):
		await GameManager.dialogo("dicaMachado")
		placaDica4 = true
