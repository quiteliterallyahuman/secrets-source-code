extends Node

@onready var Dialogue = $"../dialogue"
var continuing = false

func _ready():
	$"../camera".make_current()


func player_entered(body):
	if body.is_in_group("frank"):
		body.moveable = false
		body.velocity = Vector2.ZERO
		Dialogue.showing = true
		Dialogue.campos = $"../scroll".position
		Dialogue.text = "those were some drippy moves, frank!"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "so now, I think you deserve to know what the secret was that the squares were hiding from you."
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "so, the truth is:"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "there is no secret."
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "the squares made it up to irritate you"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "so congratulations!"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "you have just killed the entire square population"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "just because they were winding you up."
		while !continuing:
			await get_tree().process_frame
		continuing = false
		Dialogue.text = "anyway, thanks for playing and well done for completing the game!"
		while !continuing:
			await get_tree().process_frame
		continuing = false
		body.score = 1
		Dialogue.showing = false
		body.moveable = true
		$"../scroll".queue_free()
		Tools.explode(Dialogue.campos, Color.GOLD, 1.0, 1.0)

func _process(delta):
	if Input.is_action_just_pressed("continue"):
		continuing = true

func _on_dialogue_continue():
	continuing = true
