extends Node2D
var placaDica2: bool = false;
var placaDica3: bool = false;
var can_spawn:= false

const CACADOR = preload("res://Scenes/Caçador.tscn")
const LENHADOR = preload("res://Scenes/Lenhador.tscn")


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


func _on_timer_timeout() -> void:
	if can_spawn == true:
		var lista_spawners = $Spawners.get_children()
		var spawner = lista_spawners.pop_back()
		var numero_aleatorio = randi_range(1, 10)
		if numero_aleatorio < 4:
			var inimigo = CACADOR.instantiate()
			inimigo.global_position = spawner.global_position
			add_child(inimigo)
		else:
			var inimigo = LENHADOR.instantiate()
			inimigo.global_position = spawner.global_position
			add_child(inimigo)


func _on_trigger_spawn_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		can_spawn = true
		$TriggerSpawn.queue_free()
