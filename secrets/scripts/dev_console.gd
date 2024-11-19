extends Window

var infinitehealth = false
var valid_cmds = ["clear", "gd.", "new", "map", "unlockall", "pause", "unpause", "infinitehealth", "player.get_", "player.set_"]

func _on_close_requested():
	hide()

var levelnum = 7


func _on_input_text_submitted(new_text):
	cout(">> " + new_text)
	$input.clear()
	run(new_text)

func cout(text):
	$output.text += "\n" + str(text)


func run(cmd):
	var valid = false
	var cmd_idx = 0
	for i in valid_cmds:
		if cmd.begins_with(i):
			valid = true
			cmd_idx = valid_cmds.find(i)
	if valid:
		if cmd_idx == 0:
			$output.text = ""
		elif cmd_idx == 1:
			cmd = cmd.replace("gd.", "")
			if cmd.begins_with("runline<<"):
				cmd = "extends Node\n\nfunc _ready():\n\t" + cmd.replace("runline<<", "").replace("//nln", "\n").replace("//tb", "\t").replace("print(", "get_parent().cout(") + "\n\tqueue_free()"
				Tools.savetxt(cmd, "user://.gd")
				var script = load("user://.gd")
				if script.reload() == OK:
					var node = Node.new()
					node.set_script(script)
					add_child(node)
					DirAccess.remove_absolute("user://.gd")
		elif cmd_idx == 2:
			cmd = cmd.replace(" ", "").replace("new", "").replace("enemy", "res://scenes/enemies/enemy.tscn").replace("player", "res://scenes/player.tscn").replace("mapend", "res://scenes/end.tscn")
			get_tree().current_scene.add_child(load(cmd).instantiate())
		elif cmd_idx == 3:
			cmd = cmd.replace(" ", "").replace("map", "").replace("menu", "res://scenes/menu").replace("level", "res://scenes/maps/level").replace(".tscn", "") + ".tscn"
			get_tree().change_scene_to_file(cmd)
		elif cmd_idx == 4:
			var data = Tools.loadjson("user://data.json")
			data["unlocked"] = []
			for i in levelnum:
				data["unlocked"].append(str(i + 1))
			Tools.savejson(data, "user://data.json")
		elif cmd_idx == 5:
			get_tree().paused = true
		elif cmd_idx == 6:
			get_tree().paused = false
		elif cmd_idx == 7:
			if cmd.ends_with("false") or cmd.ends_with("0"):
				infinitehealth = false
			else:
				infinitehealth = true
		elif cmd_idx == 8:
			if get_tree().current_scene:
				if get_tree().current_scene.get_node("player"):
					for i in get_tree().current_scene.get_node("player").get_property_list():
						if i["name"] == cmd.replace("player.", ""):
							cout("player's " + cmd.replace("player.", "") + " : " + str(get_tree().current_scene.get_node("player").get(cmd.replace("player.", ""))))
				else:
					cout("no player")
		elif cmd_idx == 9:
			if get_tree().current_scene:
				if get_tree().current_scene.get_node("player"):
					var split = cmd.split(" ")
					for i in get_tree().current_scene.get_node("player").get_property_list():
						if i["name"] == split[0].replace("player.set_", ""):
							var val
							if split[1] == "string":
								val = str(split[2])
							elif split[1] == "int":
								val = int(split[2])
							elif split[1] == "float":
								val = float(split[2])
							elif split[1] == "vec":
								val = Vector2(float(split[2].split(",")[0]), float(split[2].split(",")[1]))
							elif split[1] == "bool":
								val = bool(split[2])
							get_tree().current_scene.get_node("player").set(split[0].replace("player.set_", ""), val)
							cout("set player's %s" % [split[0].replace("player.set_", "")])
				else:
					cout("no player")
	else:
		cout("'%s' is not a valid command. see the github repo for a list of commands" % [cmd])



func _process(delta):
	if get_tree().current_scene:
		if get_tree().current_scene.get_node("player") and infinitehealth:
			get_tree().current_scene.get_node("player").health = 6
