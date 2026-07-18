extends Area2D

@export var playerShoot: bool = false
@onready var sprite = $Sprite2D
var speed = 50.0
var direction = Vector2.RIGHT
var damage = 1

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func set_speed(dir : int) -> void:
	speed *= dir
	sprite.flip_h = true
	position += Vector2.UP * 10.0


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	if (body.name == "Player" && !playerShoot):
		body.take_damage(1,self.global_position)
		queue_free();
	if (body.is_in_group("Inimigos")):
		queue_free();
