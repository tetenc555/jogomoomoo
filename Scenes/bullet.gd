extends Area2D

@onready var sprite = $Sprite2D
var speed = 50.0
var direction = Vector2.RIGHT
var damage = 1

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func set_speed(direction : int) -> void:
	speed *= -1
	sprite.flip_h = true


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		print("Bateu no cenário!")
		queue_free()
