extends MeshInstance2D


func _process(delta):
	modulate.a = lerp(modulate.a, 0.0, delta * 2.0)


func _ready():
	await get_tree().create_timer(2.0).timeout
	queue_free()
