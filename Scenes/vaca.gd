extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -200.0
enum PowerUpType { NENHUM, MACHADO, ARMA }
var powerup_atual = PowerUpType.NENHUM
const ITEM_SCENE: Node2D = preload(#por a cena aqui)
const POWERUP_NAMES = {
	PowerUpType.NENHUM: "normal",
	PowerUpType.MACHADO: "machado",
	PowerUpType.ARMA: "arma"
}

@onready var collission = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _setAnimation(velocity_X, velocity_Y):
	if velocity_X > 0:
		flip_h = false
	elif velocity_X < 0:
		flip_h = true
	if velocity_Y == 0:
		if velocity_X != 0:
			var anim_para_tocar = "andando_" + sufixo
			if animation != anim_para_tocar:
				play(anim_para_tocar)
		else:
			var anim_para_tocar = "idle_" + sufixo
			if animation != anim_para_tocar:
				play(anim_para_tocar)
	else:
		if velocity_Y < 0:
			if animation != "pulando":
				play("pulando")
		elif velocity_Y > 0:
			if animation != "caindo":
				play("caindo")
				
func changePowerUp(novo_powerup: PowerUpType):
	match novo_powerup:
		PowerUpType.MACHADO:
			powerup_atual = novo_powerup
			# play animacao machado
		PowerUpType.ARMA:
			powerup_atual = novo_powerup
			# play animacao arma
		PowerUpType.NENHUM:
			drop_current_item()
			powerup_atual = novo_powerup
			
		_:
			print("Power-up inválido")
			
func drop_current_item():
	if powerup_atual == PowerUpType.NENHUM:
		return 

	var item_instanciado = ITEM_SCENE.instantiate();
	item_instaciado.tipo = powerup_atual
	item_instanciado.global_position = global_position
	get_parent().add_child(item_instanciado)
