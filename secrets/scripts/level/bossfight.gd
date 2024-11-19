extends Node

@onready var frank = $"../player".global_position
@onready var craig = $"../static/craig".global_position
@onready var Dialogue = $"../dialogue"
var continuing = false
var frankicon = load("res://textures/skins/blue.png")
var ended = false

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
	await get_tree().create_timer(2.0).timeout
	frank_dialogue("who... are you?")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	craig_dialogue("my name is king craig")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	craig_dialogue("and I rule the squares")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	craig_dialogue("now, what do you want, triangle? and how are you here?")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("I've had it with you squares")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("you've been terrorising my people for too long now")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("oh, and your friend mentioned a secret that was,")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("quote - ")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("'knowledge too great for you inferior triangles'")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("so, craig,")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	frank_dialogue("you gonna tell me, or am I going to have to kill you?")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	craig_dialogue("NEVER")
	while !continuing:
		await get_tree().process_frame
	continuing = false
	Dialogue.showing = false
	$"../player".moveable = true
	await get_tree().create_timer(3.0).timeout
	var loop = true
	while loop:
		$"../static/craig".texture = load("res://textures/king_craig.png")
		craig_shoot(15)
		await get_tree().create_timer(3.25).timeout
		craig_shoot(15)
		await get_tree().create_timer(3.25).timeout
		craig_shootv2(2)
		await get_tree().create_timer(3.25).timeout
		Tools.play(load("res://sound/enemyspawn.wav"))
		$"../static/craig".texture = load("res://textures/king_craig_vulnerable.png")
		if !$"../static/craig".visible:
			loop = false
		else:
			Tools.explode($"../static/craig".global_position, Color.WHITE, 2.0)
		await get_tree().create_timer(5.5).timeout
		if !$"../static/craig".visible:
			loop = false
		else:
			Tools.explode($"../static/craig".global_position, Color.WHITE, 2.0)
			Tools.play(load("res://sound/enemyspawn.wav"))

func _process(delta):
	if $"../static/collider".disabled:
		$"../static/collider/wall".position.y = move_toward($"../static/collider/wall".position.y, -1160.0, delta * 500.0)
	else:
		$"../static/collider/wall".position.y = move_toward($"../static/collider/wall".position.y, -40, delta * 500.0)
	if !$"../static/craig".visible:
			$"../static/collider".disabled = true
			$"../static/craig/collider/shape".disabled = true
	$"../camera".position.x = -$"../player".position.x
	frank = $"../camera".position
	if !Dialogue.showing:
		$"../camera".make_current()
	if Input.is_action_just_pressed("continue"):
		continuing = true
	if get_parent().maxpoints <= $"../player".score:
		$"../static/craig".hide()
		if ended == false:
			Tools.explode(craig, Color.RED, 5.0)
			Tools.give_money(250)
		ended = true


func frank_dialogue(text):
	Dialogue.bgcolour = Color.WHITE
	Dialogue.textcolour = Color.BLACK
	if Dialogue.text == text:
		Dialogue.reset_dialogue_anim()
	Dialogue.text = text
	Dialogue.icon = frankicon
	Dialogue.campos = frank
	Dialogue.camzoom = 0.25

func craig_dialogue(text):
	Dialogue.bgcolour = Color.FIREBRICK
	Dialogue.textcolour = Color.WHITE
	if Dialogue.text == text:
		Dialogue.reset_dialogue_anim()
	Dialogue.text = text
	Dialogue.icon = load("res://textures/skins/craig.png")
	Dialogue.campos = craig
	Dialogue.camzoom = 0.15


func _on_dialogue_continue():
	continuing = true

func craig_shoot(times):
	for i in range(times):
		if !Dialogue.showing and $"../static/craig".visible:
			var bullet = load("res://scenes/bulletv2.tscn").instantiate()
			get_parent().add_child(bullet)
			$"../static/craig/bulletanchor".look_at($"../player".global_position)
			bullet.rotation_degrees = $"../static/craig/bulletanchor".rotation_degrees
			bullet.global_position = $"../static/craig/bulletanchor".global_position
			Tools.explode(bullet.global_position, Color.WHITE, 0.8)
			Tools.play(load("res://sound/dashenemydeath.wav"))
			await get_tree().create_timer(0.1).timeout

func craig_shootv2(times):
	for i in range(times):
		var rand = randf_range(0.0, 360.0)
		if !Dialogue.showing and $"../static/craig".visible:
			Tools.explode($"../static/craig/bulletanchor".global_position, Color.WHITE, 0.8)
			Tools.play(load("res://sound/dashenemydeath.wav"))
			for n in range(15):
				var bullet = load("res://scenes/bulletv2.tscn").instantiate()
				get_parent().add_child(bullet)
				$"../static/craig/bulletanchor".look_at($"../player".global_position)
				bullet.rotation_degrees = float(n * 24) + rand
				bullet.global_position = $"../static/craig/bulletanchor".global_position
			await get_tree().create_timer(0.8).timeout
