extends Node

func play(sound, volume = 1.0):
	var audio = AudioStreamPlayer.new()
	audio.stream = sound
	audio.set_script(load("res://scripts/audio.gd"))
	get_parent().add_child(audio)
	print("new sound created with script ", audio.get_script(), " and stream ", audio.stream, "\n")
	audio.volume_db = linear_to_db(volume)
	audio.play()


func mean(val):
	var return_val
	for i in val:
		return_val += i
	return return_val / val.size()

func explode(pos, colour, scale, orbit = 0.0, layer = 0):
	var inst = load("res://scenes/explosion.tscn").instantiate()
	inst.set_script(load("res://scripts/particle.gd"))
	get_parent().add_child(inst)
	inst.color = colour
	inst.z_index = layer
	inst.orbit_velocity_min = -orbit
	inst.orbit_velocity_max = orbit
	inst.position = pos
	inst.scale = Vector2(scale, scale)
	inst.scale_amount_max = scale * 26.1
	inst.scale_amount_min = scale * 9.15
	print("new particles created with script ", inst.get_script(), "\n")
	inst.emitting = true


func savejson(dict, loc):
	var f = FileAccess.open(loc, FileAccess.WRITE)
	var json = JSON.new()
	f.store_line(json.stringify(dict))



func loadjson(loc):
	var f = FileAccess.open(loc, FileAccess.READ)
	if FileAccess.file_exists(loc):
		var json = JSON.new()
		return json.parse_string(f.get_as_text())
	else:
		return {}

func savetxt(txt, loc):
	var f = FileAccess.open(loc, FileAccess.WRITE)
	f.store_string(str(txt))


func loadtxt(loc, return_val = null):
	var f = FileAccess.open(loc, FileAccess.READ)
	if FileAccess.file_exists(loc):
		return f.get_as_text()
	else:
		return return_val

func give_money(amount):
	var data = loadjson("user://data.json")
	if data.has("dosh"):
		data["dosh"] += amount
	else:
		data["dosh"] = amount
	print("+£" + str(amount))
	if get_tree().current_scene.get_node("player") != null:
		get_tree().current_scene.get_node("player").message("+£" + str(amount), Color.GREEN)
	savejson(data, "user://data.json")

func roundp(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func format_time(total_seconds):
	var minutes = int(total_seconds / 60)
	var seconds = int(total_seconds) % 60
	var milliseconds = int((total_seconds - float(int(total_seconds))) * 1000)

	var time_str = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	return time_str


func _process(delta):
	process_mode = PROCESS_MODE_ALWAYS
	if Input.is_action_just_pressed("devconsole"):
		if $devconsole == null:
			var console = load("res://scenes/dev_console.tscn").instantiate()
			add_child(console)
		$devconsole.show()
	if Input.is_action_just_pressed("window"):
		match get_window().mode:
			Window.MODE_FULLSCREEN:
				get_window().mode = Window.MODE_WINDOWED
			_:
				get_window().mode = Window.MODE_FULLSCREEN

func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
