extends CanvasLayer

var screen = 0

func _ready():
	var data = Tools.loadjson("user://data.json")
	if data != null:
		if data.has("volume"):
			$menu3/volume.value = data["volume"]
		if data.has("timer_enabled"):
			$menu2/timer.button_pressed = data["timer_enabled"]
	AudioServer.set_bus_volume_db(0, linear_to_db($menu3/volume.value))

func _process(delta):
	var data = Tools.loadjson("user://data.json")
	if data != null:
		if !data.has("time"):
			$menu2/resettimer.disabled = true
		elif data["time"] == 0.0:
			$menu2/resettimer.disabled = true
		else:
			$menu2/resettimer.disabled = false
	$white.color.a = lerp($white.color.a, 0.0, delta)
	for node in $menu2.get_children():
		if node is Button and node.name != "back" and node.button_pressed:
			get_tree().change_scene_to_file("res://scenes/maps/level" + node.name + ".tscn")
		elif node is Button and node.name != "back" and data != null:
			if data.has("unlocked"):
				if data["unlocked"].has(node.name):
					node.disabled = false
	$menu3/volumeval.text = str($menu3/volume.value / 5.0)
	if screen == 0:
		$menu1.anchor_left = lerp($menu1.anchor_left, 0.0, delta * 7.0)
		$menu1.anchor_right = lerp($menu1.anchor_right, 1.0, delta * 7.0)
		$menu2.anchor_left = lerp($menu2.anchor_left, 1.0, delta * 7.0)
		$menu2.anchor_right = lerp($menu2.anchor_right, 2.0, delta * 7.0)
		$menu3.anchor_left = lerp($menu3.anchor_left, -1.0, delta * 7.0)
		$menu3.anchor_right = lerp($menu3.anchor_right, 0.0, delta * 7.0)
	elif screen == -1:
		$menu1.anchor_left = lerp($menu1.anchor_left, 1.0, delta * 7.0)
		$menu1.anchor_right = lerp($menu1.anchor_right, 2.0, delta * 7.0)
		$menu2.anchor_left = lerp($menu2.anchor_left, 2.0, delta * 7.0)
		$menu2.anchor_right = lerp($menu2.anchor_right, 3.0, delta * 7.0)
		$menu3.anchor_left = lerp($menu3.anchor_left, 0.0, delta * 7.0)
		$menu3.anchor_right = lerp($menu3.anchor_right, 1.0, delta * 7.0)
	else:
		$menu1.anchor_left = lerp($menu1.anchor_left, -1.0, delta * 7.0)
		$menu1.anchor_right = lerp($menu1.anchor_right, 0.0, delta * 7.0)
		$menu2.anchor_left = lerp($menu2.anchor_left, 0.0, delta * 7.0)
		$menu2.anchor_right = lerp($menu2.anchor_right, 1.0, delta * 7.0)
		$menu3.anchor_left = lerp($menu3.anchor_left, -2.0, delta * 7.0)
		$menu3.anchor_right = lerp($menu3.anchor_right, -1.0, delta * 7.0)

func _on_play_pressed():
	screen = 2
	Tools.play(load("res://sound/explode.wav"))


func _on_back_pressed():
	screen = 0
	Tools.play(load("res://sound/explode.wav"))

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()


func _on_options_pressed():
	screen = -1
	Tools.play(load("res://sound/explode.wav"))


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	var data = Tools.loadjson("user://data.json")
	data["volume"] = value
	Tools.savejson(data, "user://data.json")
	Tools.play(load("res://sound/shoot.wav"))


func _on_customise_pressed():
	get_tree().change_scene_to_file("res://scenes/customise.tscn")


func _on_intro_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_resettimer_pressed():
	var data = Tools.loadjson("user://data.json")
	data["time"] = 0.0
	Tools.savejson(data, "user://data.json")


func _on_timertoggle_pressed():
	var data = Tools.loadjson("user://data.json")
	data["timer_enabled"] = $menu2/timer.button_pressed
	Tools.savejson(data, "user://data.json")


func credits():
	get_tree().change_scene_to_file("res://scenes/maps/level9.tscn")
