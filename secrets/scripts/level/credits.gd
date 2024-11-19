extends Node2D

var speed

func _process(delta):
	speed = 40.0 * (float(Input.is_action_pressed("continue")) + 1.0)
	$canvas/text.position.y -= delta * speed
	print($canvas/text.position.y)
	if $canvas/text.position.y <= -448.0 or Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
