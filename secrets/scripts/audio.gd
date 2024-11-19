extends AudioStreamPlayer

func _ready():
	await get_tree().create_timer(2.0).timeout
	print("\nremoving ", self, "\n")
	queue_free()
