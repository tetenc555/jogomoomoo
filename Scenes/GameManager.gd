extends Node

enum PowerUpType { NENHUM, MACHADO, ARMA }

const POWERUP_NAMES = {
	PowerUpType.NENHUM: "normal",
	PowerUpType.MACHADO: "machado",
	PowerUpType.ARMA: "arma"
}

var isDialog: bool

func dialogo(nomeDialogo):
	GameManager.isDialog = true;
	var meu_dialogo = load("res://Dialogues/HistoriaInicial.dialogue")
	DialogueManager.show_dialogue_balloon(meu_dialogo,nomeDialogo)
	await DialogueManager.dialogue_ended
	GameManager.isDialog = false;
