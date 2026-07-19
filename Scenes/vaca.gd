extends CharacterBody2D

var health := 3
var invulnerable := false
var dead = false
var tomou_dano : bool = false

const BULLET = preload("res://Scenes/Bullet.tscn")
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var powerup_atual = GameManager.PowerUpType.NENHUM
@onready var sprite = $AnimatedSprite2D
@onready var machadoArea = $MachadoArea
@onready var machado_distancia_x: float = abs(machadoArea.position.x)

func atualizar_posicao_ataque():
	var direcao = get_direction()
	
	if direcao == -1:
		machadoArea.position.x = -38.5  # <--- Teste aumentar esse valor
		
	else:
		machadoArea.position.x = 0.0   # <--- Teste diminuir esse valor
		
		
func get_direction():
	if sprite.flip_h == false:
		return 1
	else: 
		return -1

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
	if direction and !tomou_dano:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	setAnimation(velocity.x,velocity.y)
	move_and_slide()
	
	if Input.is_action_just_pressed("Atirar"):
		if powerup_atual == GameManager.PowerUpType.ARMA:
			shoot()
		if powerup_atual == GameManager.PowerUpType.MACHADO:
			machadada()
	
	if (powerup_atual != GameManager.PowerUpType.NENHUM && Input.is_action_just_pressed("Dropar item")):
		drop_current_item();
	
	atualizar_posicao_ataque();


func take_damage(amount: int, enemy_position: Vector2):
	if invulnerable:
		return
	tomou_dano = true
	health -= amount
	invulnerable = true	
	#Empurrão para trás
	velocity.y = -180
	velocity.x = 900 * get_direction() * -1
	
	if health<=0:
		die()
		return
	await get_tree().create_timer(1.0).timeout
	invulnerable = false
	tomou_dano = false

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
	if novo_powerup == self.powerup_atual:
		return false
	match novo_powerup:
		GameManager.PowerUpType.MACHADO:
			powerup_atual = novo_powerup
			return true
			# play animacao machado
		GameManager.PowerUpType.ARMA:
			powerup_atual = novo_powerup
			return true
			# play animacao arma
		GameManager.PowerUpType.NENHUM:
			drop_current_item()
			powerup_atual = novo_powerup
			return true
			
		_:
			print("Power-up inválido")
	
func drop_current_item():
	if powerup_atual == GameManager.PowerUpType.NENHUM:
		return 
	powerup_atual = GameManager.PowerUpType.NENHUM
	

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

func shoot():
	var shot = BULLET.instantiate()
	get_parent().add_child(shot)
	shot.global_position = self.global_position
	if sprite.flip_h == true:
		shot.set_speed(-1)
	else :
		shot.set_speed(1)	
	shot.playerShoot=true
	get_tree().current_scene.add_child(shot)
	
func machadada():
	sprite.play("machadada")
	var corpos_dentro = machadoArea.get_overlapping_bodies()
	
	for body in corpos_dentro:
		if(body.is_in_group("Inimigos") || body.name=="Tree"):
			body.die();
