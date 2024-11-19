extends Control

var changing = false

func _on_menu_pressed():
	changing = true
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _process(delta):
	$white.color.a = lerp($white.color.a, float(changing), delta * 5.0)
