extends CPUParticles2D

func _ready():
	await get_tree().create_timer(2.0).timeout
	print("removing ", self)
	queue_free()
