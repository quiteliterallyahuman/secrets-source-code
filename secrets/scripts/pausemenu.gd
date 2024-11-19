extends CanvasLayer

func _ready():
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and $"../canvas/score".visible:
		get_tree().paused = !get_tree().paused
	visible = get_tree().paused


func resume():
	get_tree().paused = false


func quit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
