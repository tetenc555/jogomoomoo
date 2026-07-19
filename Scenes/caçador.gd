extends CharacterBody2D

const SPEED = 70.0
const JUMP_VELOCITY = -200.0
var direction := 1
var dead := false
var player : CharacterBody2D = null

@export var bullet_scene : PackedScene = preload("res://Scenes/Bullet.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var wall_detector = $WallDetector
@onready var floor_detector = $FloorDetector
@onready var vision_ray = $VisionRay
@onready var shoot_point = $ShootPoint
@onready var shoot_timer = $ShootTimer
var item_scene = preload("res://Scenes/collectible_item.tscn")

func get_direction():
	if sprite.flip_h == false:
		return 1
	else: 
		return -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	print(player)

func patrol():
	velocity.x = direction * SPEED
	if wall_detector.is_colliding() or !floor_detector.is_colliding():
		turn()

func turn():
	direction *= -1
	sprite.flip_h = direction < 0
	
	wall_detector.target_position.x = 12*direction
	wall_detector.position.x = 11*direction
	
	floor_detector.position.x = 11*direction
	
	vision_ray.target_position.x = 300*direction
	shoot_point.position.x = 10*direction

func can_see_player() -> bool:
	if player == null:
		print("Player é null")
		return false
	
	var distance = player.global_position - self.global_position
	print("Distancia: ", distance)
	
	if abs(distance.x) > 300:
		print("Longe")
		return false
	
	if sign(distance.x) != direction:
		print("Jogador atras")
		return false
	
	vision_ray.target_position = distance
	vision_ray.force_raycast_update()
	
	if !vision_ray.is_colliding():
		print("Raio nao colidindo")
		return false
	var collider = vision_ray.get_collider()
	print("Raio bateu em:", collider)
	
	if collider == player:
		print("Enxerga o jogador")
		return true
	
	return false

func _on_shoot_timer_timeout():
	print("Timer disparou")
	if can_see_player():
		print("Caçador atira")
		shoot()

func shoot():
	print("Atirando")
	var bullet = bullet_scene.instantiate()
	
	bullet.playerShoot = false
	bullet.global_position = shoot_point.global_position
	
	if direction == -1:
		bullet.direction = Vector2.LEFT
		bullet.set_speed(-1)
	else:
		bullet.direction = Vector2.RIGHT
	get_tree().current_scene.add_child(bullet)

func _physics_process(delta: float) -> void:
	if dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_see_player():
		velocity.x = 0
		if shoot_timer.is_stopped():
			print("Iniciando timer")
			shoot_timer.start()
	else:
		patrol()
		if !shoot_timer.is_stopped():
			shoot_timer.stop()
	
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die():
	var instantied_item = item_scene.instantiate()
	instantied_item.type = GameManager.PowerUpType.ARMA
	instantied_item.global_position = self.global_position + Vector2(25 * get_direction(), 0)
	get_parent().add_child(instantied_item)
	if instantied_item.has_method("aplicar_impulso_drop"):
		instantied_item.aplicar_impulso_drop(get_direction())
	dead = true
	collision_layer = 0
	collision_mask = 0
	$CollisionShape2D.disabled = true
	
	velocity = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	queue_free()

func _on_head_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		print("lenhador morreu")
		velocity = Vector2.ZERO
		die()
		body.velocity.y = -350
