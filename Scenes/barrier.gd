extends StaticBody2D

var hp := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die() -> void:
	if hp > 0:
		hp -= 1
	if hp <= 0:
		collision_layer = 0
		collision_mask = 0
		$CollisionShape2D.disabled = true
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.0)
		await tween.finished
		SceneController.changeSceneTo(load("res://Scenes/Mapas/Mapa03.tscn"),"CircleToon")
		queue_free()
		
