extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -200.0
var item_scene = preload("res://Scenes/collectible_item.tscn")

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
	
	velocity.x = direction * SPEED
	
	if wall_detector.is_colliding() or not floor_detector.is_colliding():
		turn()
	
	move_and_slide()

var direction := -1
var dead := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var sprite = $AnimatedSprite2D
@onready var wall_detector = $WallDetector # Vira ao encontrar parede
@onready var floor_detector = $FloorDetector #Virar ao encontrar penhasco
@export var damage = 1

func turn():
	direction *= -1
	sprite.flip_h = direction < 0
	wall_detector.target_position.x *= -1
	wall_detector.position.x *= -1
	
	floor_detector.position.x *= -1

func die():
	dead = true
	collision_layer = 0
	collision_mask = 0
	$CollisionShape2D.disabled = true
	
	velocity = Vector2.ZERO
	var instantied_item = item_scene.instantiate()
	instantied_item.type = GameManager.PowerUpType.MACHADO
	instantied_item.global_position = self.global_position + Vector2(25 * get_direction(), 0)
	get_parent().add_child(instantied_item)
	if instantied_item.has_method("aplicar_impulso_drop"):
		instantied_item.aplicar_impulso_drop(get_direction())
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()
	

func _on_head_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		die()
		body.velocity.y = -350


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, global_position)
