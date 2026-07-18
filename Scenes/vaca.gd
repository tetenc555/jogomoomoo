extends CharacterBody2D

var health := 3
var invulnerable := false
var dead = false

const SPEED = 150.0
const JUMP_VELOCITY = -200.0
var powerup_atual = GameManager.PowerUpType.NENHUM
@onready var sprite = $AnimatedSprite2D
const ITEM_SCENE = preload("res://Scenes/collectibles/collectible_item.tscn")

@onready var collission = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if dead:
		return
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
	setAnimation(velocity.x,velocity.y)
	move_and_slide()

func take_damage(amount: int, enemy_position: Vector2):
	if invulnerable:
		return
	health -= amount
	invulnerable = true
	
	#Empurrão para trás
	velocity.y = -250
	velocity.x = sign(global_position.x - enemy_position.x) * 200
	
	if health<=0:
		die()
		return
	await get_tree().create_timer(1.0).timeout
	invulnerable = false

func die():
	
	dead = true
	collision_layer = 0
	collision_mask = 0
	$CollisionShape2D.disabled = true
	
	velocity = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	queue_free()

				
func changePowerUp(novo_powerup: GameManager.PowerUpType):
	match novo_powerup:
		GameManager.PowerUpType.MACHADO:
			powerup_atual = novo_powerup
			# play animacao machado
		GameManager.PowerUpType.ARMA:
			powerup_atual = novo_powerup
			# play animacao arma
		GameManager.PowerUpType.NENHUM:
			drop_current_item()
			powerup_atual = novo_powerup
			
		_:
			print("Power-up inválido")
			
func drop_current_item():
	if powerup_atual == GameManager.PowerUpType.NENHUM:
		return 

	var item_instanciado = ITEM_SCENE.instantiate();
	item_instanciado.tipo = powerup_atual
	item_instanciado.global_position = global_position
	get_parent().add_child(item_instanciado)

func setAnimation(velocity_X, velocity_Y):
	if velocity_X > 0:
		sprite.flip_h = false
	elif velocity_X < 0:
		sprite.flip_h = true
	if velocity_Y == 0:
		if velocity_X != 0:
			var anim_para_tocar = "andando_" + GameManager.POWERUP_NAMES[powerup_atual]
			if sprite.animation != anim_para_tocar:
				sprite.play(anim_para_tocar)
		else:
			var anim_para_tocar = "idle_" + GameManager.POWERUP_NAMES[powerup_atual]
			if sprite.animation != anim_para_tocar:
				sprite.play(anim_para_tocar)
	else:
		if velocity_Y < 0:
			if sprite.animation != "pulando":
				sprite.play("pulando")
		elif velocity_Y > 0:
			if sprite.animation != "caindo":
				sprite.play("caindo")
