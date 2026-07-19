extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.isDialog = true;
	var meu_dialogo = preload("res://Dialogues/HistoriaInicial.dialogue")
	DialogueManager.show_dialogue_balloon(meu_dialogo, "historiaMapa01")
	await DialogueManager.dialogue_ended
	GameManager.isDialog = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
