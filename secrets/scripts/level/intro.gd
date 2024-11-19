extends Node2D

var ended = false
var maxpoints = 1
@onready var frank = $frank.global_position
@onready var enemy = $enemy.global_position
@onready var Dialogue = $dialogue
var continuing = false
var anim_frame = 0
var frankicon = load("res://textures/skins/blue.png")

func _ready():
	Tools.play(load("res://sound/enemyspawn.wav"))
	if Tools.loadjson("user://data.json").has("skin"):
		if Tools.loadjson("user://data.json")["skin"] == 0:
			frankicon = load("res://textures/skins/blue.png")
		elif Tools.loadjson("user://data.json")["skin"] == 1:
			frankicon = load("res://textures/skins/red.png")
		elif Tools.loadjson("user://data.json")["skin"] == 2:
			frankicon = load("res://textures/skins/yellow.png")
		elif Tools.loadjson("user://data.json")["skin"] == 3:
			frankicon = load("res://textures/skins/white.png")
	while anim_frame == 0:
		await get_tree().process_frame
	frank_dialogue("oh...")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("...hello, square")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("hello, frank")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("what do you want?")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("I wouldn't need anything from you, you ugly square")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("you've done enough bad to us already")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("shut up, triangle")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("you cant say much yourself")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("ok then, square")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("what do you have that we don't?")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("oh, yes")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("we have a secret")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("knowledge too great for you inferior triangles")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("ok, thats enough")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("I've had it with you quadrilaterals")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("and I am going to find out said secret")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("if it's the last thing I do")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	square_dialogue("try me")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	Dialogue.showing = false
	$player.moveable = true
	anim_frame = 2

func _process(delta):
	frank = $frank.global_position
	enemy = $enemy.global_position
	match anim_frame:
		0:
			$player.position = $frank.position
			$player.moveable = false
			$player.rotation_degrees = $frank.rotation_degrees + 90.0
			$enemy2.position = $enemy.position
			$nav.enabled = false
			$frank.look_at(Vector2(-143.0, 52.0))
			$frank.rotation_degrees -= 90.0
			$frank.global_position.x = move_toward($frank.global_position.x, -143.0, delta * 150.0)
			$frank.global_position.y = move_toward($frank.global_position.y, 52.0, delta * 150.0)
			
			$enemy.global_position.x = move_toward($enemy.global_position.x, 64.0, delta * 80.0)
			$enemy.global_position.y = move_toward($enemy.global_position.y, 0.0, delta * 80.0)
			
			if $frank.global_position == Vector2(-143.0, 52.0):
				anim_frame = 1
		1:
			$player.position = $frank.position
			$player.moveable = false
			$player.rotation_degrees = $frank.rotation_degrees + 90.0
			$enemy2.position = $enemy.position
			$nav.enabled = false
		2:
			$nav.enabled = true
	if Input.is_action_just_pressed("continue"):
		continuing = true
	if $player.score >= maxpoints:
		$player.indicate($end.position)
		if !ended:
			var inst = load("res://scenes/end.tscn").instantiate()
			inst.position = $end.position
			inst.name = "end"
			add_child(inst)
			Tools.explode($end.position, Color(1.0, 1.0, 1.0), 1.0)
			Tools.play(load("res://sound/spawn.wav"), 3.0)
			ended = true


func frank_dialogue(text):
	Dialogue.bgcolour = Color.WHITE
	Dialogue.textcolour = Color.BLACK
	if Dialogue.text == text:
		Dialogue.reset_dialogue_anim()
	Dialogue.text = text
	Dialogue.icon = frankicon
	Dialogue.campos = frank

func square_dialogue(text):
	Dialogue.bgcolour = Color.BLACK
	Dialogue.textcolour = Color.WHITE
	if Dialogue.text == text:
		Dialogue.reset_dialogue_anim()
	Dialogue.text = text
	Dialogue.icon = load("res://textures/skins/square.png")
	Dialogue.campos = enemy


func _on_dialogue_continue():
	continuing = true
