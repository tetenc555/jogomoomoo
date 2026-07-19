extends CharacterBody2D

const SPEED = 70.0
const JUMP_VELOCITY = -200.0
var direction := 1
var dead := false
var player : CharacterBody2D = null

@export var bullet_scene : PackedScene

@onready var sprite = $AnimatedSprite
@onready var wall_detector = $WallDetector
@onready var floor_detector = $FloorDetector
@onready var vision_ray = $VisionRay
@onready var shoot_point = $ShootPoint
@onready var shoot_timer = $ShootTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func patrol():
	velocity.x = direction * SPEED
	if wall_detector.is_colliding() or !floor_detector.is_colliding():
		turn()

func turn():
	direction *= -1
	sprite.flip_h = direction < 0
	wall_detector.target_position.x *= -1
	wall_detector.position.x *= -1
	
	floor_detector.position.x *= -1
	
	vision_ray.target_position.x *= -1
	shoot_point.position.x *= -1

func can_see_player() -> bool:
	
	var distance = player.global.position() - global_position
	if abs(distance.x > 300):
		return false
	if sign(distance.x) != direction:	
		return false
	vision_ray.target_position = distance
	if(vision_ray.is_colliding()):
		return vision_ray.get_collider() == player
	return false

func _on_shoot_timer_timeout():
	if can_see_player():
		shoot()

func shoot():
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
	
	velocity.x = direction * SPEED
	
	if can_see_player():
		
		velocity.x = 0
		
		if shoot_timer.is_stopped():
			shoot_timer.start()
		else:
			if !shoot_timer.is_stopped():
				shoot_timer.stop()
	
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

func _on_head_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		print("lenhador morreu")
		velocity = Vector2.ZERO
		die()
		body.velocity.y = -350
