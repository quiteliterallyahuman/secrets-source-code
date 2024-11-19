extends Node2D

var ended = false

@export var endscene = ""
@export var include_enemies = [load("res://scenes/enemies/enemy.tscn")]
@export var maxpoints = 20
@export var max_spawnpositions = 3

func _ready():
	if name != "##":
		$player.message(name.to_upper(), Color(1.0, 1.0, 1.0))
	Tools.explode($player.position, Color(1.0, 1.0, 1.0), 1.5)
	Tools.play(load("res://sound/explode.wav"))
	await get_tree().create_timer(5.0).timeout
	spawn()
	$spawntimer.start()

func spawn():
	if !$player.score >= maxpoints and max_spawnpositions != 0:
		var spawnposgroups = []
		var group = []
		for i in get_children():
			if i.name.begins_with("enemyspawn"):
				group.append(i)
				if group.size() >= 4:
					spawnposgroups.append(group)
					group = []
		if group != []:
			spawnposgroups.append(group)
		for current_group in range(spawnposgroups.size()):
			var inst = include_enemies.pick_random().instantiate()
			var pos = spawnposgroups[current_group - 1].pick_random().position
			Tools.explode(pos, Color(1.0, 1.0, 1.0), 1.5)
			inst.position = pos
			add_child(inst)
		Tools.play(load("res://sound/enemyspawn.wav"))

func _process(delta):
	if $player.score >= maxpoints:
		$player.indicate($end.position)
		if !ended:
			var inst = load("res://scenes/end.tscn").instantiate()
			inst.position = $end.position
			add_child(inst)
			inst.name = "end"
			Tools.explode($end.position, Color(1.0, 1.0, 1.0), 1.0)
			Tools.play(load("res://sound/spawn.wav"), 3.0)
			ended = true

func _on_spawntimer_timeout():
	spawn()
