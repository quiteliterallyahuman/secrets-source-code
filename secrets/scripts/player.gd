extends CharacterBody2D

@export var music = preload("res://sound/nic music for github game off 2024.wav")
@export var give_end_money = true
var rot = 0.0
var time = 0.0
var deathtimer_running = false
var health = 6
var score = 0
var grapplenode
var grapplenodeprev = Vector2.ZERO
var grapplepos = null
var points = []
@onready var prevpos = position
var speed = 1.0
var friction = 1.25
@export var moveable = true
@export var straight_in = false


func _physics_process(delta):
	$camera.zoom = lerp($camera.zoom, Vector2(0.25, 0.25), delta * 3.0)
	$canvas/message.modulate.a = lerp($canvas/message.modulate.a, 0.0, delta * 2.0)
	if Tools.loadjson("user://data.json") != null and Tools.loadjson("user://data.json").has("skin"):
		if Tools.loadjson("user://data.json")["skin"] == 0:
			$visual.modulate.r = lerp($visual.modulate.r, speed / 1500.0, delta * 10.0)
			$visual.modulate.g = 1.0
			$visual.modulate.b = 1.0
		elif Tools.loadjson("user://data.json")["skin"] == 1:
			$visual.modulate.r = 1.0
			$visual.modulate.g = lerp($visual.modulate.g, speed / 1500.0, delta * 10.0)
			$visual.modulate.b = 0.0
		elif Tools.loadjson("user://data.json")["skin"] == 2:
			$visual.modulate.r = 1.0
			$visual.modulate.g = 1.0
			$visual.modulate.b = lerp($visual.modulate.b, speed / 1500.0, delta * 10.0)
		elif Tools.loadjson("user://data.json")["skin"] == 3:
			$visual.modulate.r = lerp($visual.modulate.r, -(speed / 1500.0) + 1.0, delta * 10.0)
			$visual.modulate.g = lerp($visual.modulate.g, -(speed / 1500.0) + 1.0, delta * 10.0)
			$visual.modulate.b = lerp($visual.modulate.b, -(speed / 1500.0) + 1.0, delta * 10.0)
	else:
		$visual.modulate.r = lerp($visual.modulate.r, speed / 1500.0, delta * 10.0)
		$visual.modulate.g = 1.0
		$visual.modulate.b = 1.0
	rot += delta * 100.0
	$normal.global_rotation_degrees = 0.0
	$"normal/grapple ui".rotation_degrees = rot
	if grapplepos != null:
		$"normal/grapple ui".global_position = grapplepos
	$"normal/grapple ui".visible = grapplepos != null
	if !$canvas/speedrun_timer.visible:
		time = 0.0
	$canvas/exit.visible = $canvas/healthanchor.visible
	if $"canvas/mobile tap detector".visible:
		$"canvas/mobile tap detector".scale = $"canvas/mobile tap detector anchor".size
		$"canvas/mobile tap detector".position = $"canvas/mobile tap detector anchor".position + Vector2($"canvas/mobile tap detector anchor".size / 2.0)
	if Tools.loadjson("user://data.json") != null and Tools.loadjson("user://data.json").has("timer_enabled"):
		$canvas/speedrun_timer.visible = Tools.loadjson("user://data.json")["timer_enabled"]
		var data = Tools.loadjson("user://data.json")
		if data.has("time") and !data["timer_enabled"]:
			data["time"] = 0.0
		Tools.savejson(data, "user://data.json")
	if Tools.loadjson("user://data.json") != null and Tools.loadjson("user://data.json").has("time"):
		time = Tools.loadjson("user://data.json")["time"]
	if $canvas/healthanchor.visible:
		if Tools.loadjson("user://data.json").has("timer_enabled"):
			if Tools.loadjson("user://data.json")["timer_enabled"]:
				time += delta
		else:
			time += delta
	$canvas/speedrun_timer.text = Tools.format_time(Tools.roundp(time, 2))
	var data = Tools.loadjson("user://data.json")
	if Tools.loadjson("user://data.json") != null:
		data["time"] = time
	Tools.savejson(data, "user://data.json")
	if get_parent().get_node("dialogue") != null:
		if get_parent().get_node("dialogue").showing and get_parent().get_node("dialogue").text != "":
			moveable = false
		health = clamp(health, 0, 6)
	if moveable:
		if health <= 0:
			get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")
		$canvas/healthanchor/sprite.frame = health
		if score >= get_parent().maxpoints:
			score = get_parent().maxpoints
			$canvas/score.label_settings.font_color = Color(0.0, 1.0, 0.0)
			$music.stop()
			$canvas/healthanchor.hide()
		else:
			$canvas/score.label_settings.font_color = Color(1.0, 1.0, 1.0)
		$canvas/score.text = str(score) + " / " + str(get_parent().maxpoints)
		$canvas/abberation.material.set_shader_parameter("strength", lerp($canvas/abberation.material.get_shader_parameter("strength"), 0.15 * speed / 1000.0, delta * 3.0))
	
		if speed > 1200.0:
			var inst = load("res://scenes/trail.tscn").instantiate()
			inst.position = position
			inst.rotation = rotation - deg_to_rad(90)
			get_parent().add_child(inst)
		grapplenodeprev = grapplenode
		$raycast.target_position = to_local(get_global_mouse_position()) * 1.2
		if $raycast.is_colliding() and $raycast.get_collider() != null:
			if $raycast.get_collider().is_in_group("grapple"):
				grapplepos = $raycast.get_collider().global_position
				grapplenode = $raycast.get_collider()
			else:
				grapplepos = null
		else:
			grapplepos = null
		$grapple.points = points
		speed = (position.distance_to(prevpos)) / delta
		prevpos = position
		if (Input.is_action_pressed("grapple") or (Input.is_action_pressed("shoot") and Input.is_action_pressed("grapple_mobile"))) and grapplepos != null:
			velocity -= (global_position - grapplepos) / (friction * 5.0)
		if ((Input.is_action_pressed("grapple") or (Input.is_action_pressed("shoot") and Input.is_action_pressed("grapple_mobile"))) and grapplenode != grapplenodeprev) or (Input.is_action_just_pressed("grapple")):
			Tools.play(load("res://sound/grapple.wav"))
			Tools.explode(position, Color(1.0, 1.0, 1.0), 0.25)
		elif Input.is_action_just_pressed("shoot"):
			shoot()
		match (Input.is_action_pressed("grapple") or (Input.is_action_pressed("shoot") and Input.is_action_pressed("grapple_mobile"))) and grapplepos != null:
			false:
				points = []
			true:
				points = [Vector2.ZERO, to_local(grapplepos)]
		look_at(get_global_mouse_position())
		$grapple.points = points
	else:
		grapplepos = null
		points = []
		$grapple.points = points
		speed = 0.0
	velocity = lerp(velocity, Vector2.ZERO, delta * friction)
	move_and_slide()

func knockback(direction, impulse):
	velocity += -direction * impulse
	velocity.x = clamp(velocity.x, -700.0, 700.0)
	velocity.y = clamp(velocity.y, -700.0, 700.0)


func shoot():
	look_at(get_global_mouse_position())
	Tools.play(load("res://sound/shoot.wav"))
	knockback($direction.global_position - global_position, 700.0)
	Tools.explode(position, Color(1.0, 1.0, 1.0), 0.25)
	var inst = load("res://scenes/bullet.tscn").instantiate()
	inst.rotation = rotation
	inst.position = position
	get_parent().add_child(inst)

func _ready():
	$music.stream = music
	while !moveable:
		if get_tree() != null:
			await get_tree().process_frame

	Tools.play(load("res://sound/level_begin.wav"))
	if get_parent().name != "##":
		var data = Tools.loadjson("user://data.json")
		if data.has("unlocked"):
			if !data["unlocked"].has(str(int(get_tree().current_scene.name.replace("level", "")))):
				data["unlocked"].append(str(int(get_tree().current_scene.name.replace("level", ""))))
				data["unlocked"].sort()
		else:
			data["unlocked"] = [str(int(get_tree().current_scene.name.replace("level", "")))]
		Tools.savejson(data, "user://data.json")
		message(get_parent().name.to_upper(), Color(1.0, 1.0, 1.0))
		if !straight_in:
			await get_tree().create_timer(2.0).timeout
			message("3", Color(0.0, 1.0, 0.0))
			await get_tree().create_timer(1.0).timeout
			message("2", Color(1.0, 0.647, 0.0))
			await get_tree().create_timer(1.0).timeout
			message("1", Color(1.0, 0.0, 0.0))
			await get_tree().create_timer(1.0).timeout
			message("FIGHT", Color(1.0, 0.0, 0.0))
		$canvas/healthanchor.show()
		$canvas/score.show()
		$music.play()


func _on_detect_area_entered(area):
	if area.is_in_group("enemy"):
		if speed > 800:
			Tools.play(load("res://sound/dashenemydeath.wav"))
			area.get_parent().health -= 3
			if !speed > 1300:
				knockback(area.global_position - global_position, 10.0)
			Tools.explode(area.global_position, Color(1.0, 0.0, 0.0), 1.0)
		else:
			knockback(area.global_position - global_position, 10.0)
			Tools.play(load("res://sound/explode.wav"))
			if !deathtimer_running:
				start_deathtimer()
				health -= 1
				area.get_parent().velocity += area.global_position - global_position * 10.0
				area.get_parent().velocity.x = clamp(area.get_parent().velocity.x, -700.0, 700.0)
				area.get_parent().velocity.y = clamp(area.get_parent().velocity.y, -700.0, 700.0)
	if area.is_in_group("bouncy"):
		knockback(area.global_position - global_position, speed / 60.0)
	if area.is_in_group("end"):
		if give_end_money:
			Tools.give_money(score * 2)
		var data = Tools.loadjson("user://data.json")
		if data.has("unlocked"):
			if !data["unlocked"].has(str(int(get_tree().current_scene.name.replace("level", "")) + 1)):
				data["unlocked"].append(str(int(get_tree().current_scene.name.replace("level", "")) + 1))
				data["unlocked"].sort()
		else:
			data["unlocked"] = [str(int(get_tree().current_scene.name.replace("level", "")) + 1)]
		Tools.savejson(data, "user://data.json")
		print("res://scenes/maps/level" + str(int(get_tree().current_scene.name.replace("level", "")) + 1))
		if !"endscene" in get_parent():
			get_tree().change_scene_to_file("res://scenes/maps/level" + str(int(get_tree().current_scene.name.replace("level", "")) + 1) + ".tscn")
		elif get_parent().endscene != "":
			get_tree().change_scene_to_file(get_parent().endscene)
		else:
			get_tree().change_scene_to_file("res://scenes/maps/level" + str(int(get_tree().current_scene.name.replace("level", "")) + 1) + ".tscn")

func indicate(pos):
	$indicator.look_at(pos)
	$indicator.show()

func message(txt, colour):
	$canvas/message.text = txt
	$canvas/message.modulate = colour
	$canvas/message.modulate.a = 1.0

func start_deathtimer():
	deathtimer_running = true
	$deathtimer.start()

func _on_deathtimer_timeout():
	deathtimer_running = false


func exit():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
