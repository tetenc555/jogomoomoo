extends Area2D

@export var playerShoot: bool = false
@onready var sprite = $Sprite2D
var speed = 50.0
var direction = Vector2.RIGHT
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func set_speed(direction : int) -> void:
	speed *= -1
	sprite.flip_h = true



func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" && !playerShoot):
		body.take_damage(1,self.global_position)
		queue_free();
	if (body.is_in_group("Inimigos")):
		#toma dano
		queue_free();
