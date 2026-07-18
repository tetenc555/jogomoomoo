extends Area2D

@export var speed = 2.0
var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	#Se for o player da dano 
	if body.name == "Player":
		queue_free()
	#Se for terreno só some
	else:
		queue_free()
