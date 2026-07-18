extends CharacterBody2D

var health := 3
var invulnerable := false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dead = false

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
