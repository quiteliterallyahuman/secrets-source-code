extends Node2D

func _ready():
	var inst = load("res://scenes/grapple_empty.tscn").instantiate()
	inst.position = position
	get_parent().add_child(inst)

func _on_particletimer_timeout():
	Tools.explode(global_position, Color(1.0, 1.0, 1.0, 0.8), 0.5, 0.5)
	$particletimer.start()
