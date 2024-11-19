extends Control

var money = 0

func _ready():
	get_tree().paused = false
	Tools.play(load("res://sound/explode.wav"))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_items_item_selected(index, at_position, mouse_button_index):
	if $items.get_item_text(index) == "":
		$anchor/visual.rotation_degrees = -90.0
		Tools.play(load("res://sound/explode.wav"))
		Tools.explode($anchor.position, Color(1.0, 1.0, 1.0), 1.0)
		var data = Tools.loadjson("user://data.json")
		data["skin"] = index
		Tools.savejson(data, "user://data.json")
	else:
		var cost = int($items.get_item_text(index).replace("£", ""))
		if money >= cost:
			print("bought item " + str(index))
			var data = Tools.loadjson("user://data.json")
			data["dosh"] -= cost
			data["skin"] = index
			if data.has("owned"):
				data["owned"].append(index)
			else:
				data["owned"] = [index]
			Tools.savejson(data, "user://data.json")
			$anchor/visual.rotation_degrees = -90.0
			Tools.play(load("res://sound/explode.wav"))
			Tools.explode($anchor.position, Color(1.0, 1.0, 1.0), 1.0)

func _process(delta):
	var data = Tools.loadjson("user://data.json")
	if data.has("dosh"):
		money = data["dosh"]
	else:
		data["dosh"] = 0
		Tools.savejson(data, "user://data.json")
	if data.has("owned"):
		for i in data["owned"]:
			$items.set_item_text(i, "")
	$current.text = "£" + str(money)
	$anchor/visual.rotate(delta / 3.0)
	if Tools.loadjson("user://data.json").has("skin"):
		if Tools.loadjson("user://data.json")["skin"] == 0:
			$anchor/visual.modulate.r = 0.0
			$anchor/visual.modulate.g = 1.0
			$anchor/visual.modulate.b = 1.0
		elif Tools.loadjson("user://data.json")["skin"] == 1:
			$anchor/visual.modulate.r = 1.0
			$anchor/visual.modulate.g = 0.0
			$anchor/visual.modulate.b = 0.0
		elif Tools.loadjson("user://data.json")["skin"] == 2:
			$anchor/visual.modulate.r = 1.0
			$anchor/visual.modulate.g = 1.0
			$anchor/visual.modulate.b = 0.0
		elif Tools.loadjson("user://data.json")["skin"] == 3:
			$anchor/visual.modulate.r = 1.0
			$anchor/visual.modulate.g = 1.0
			$anchor/visual.modulate.b = 1.0
