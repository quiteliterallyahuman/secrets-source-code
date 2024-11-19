extends Node2D

var speed = 500.0

func _process(delta):
	$bullet.position.x += delta * speed


func _on_bullet_body_entered(body):
	if !$bullet/mesh.modulate == Color.RED:
		if body is StaticBody2D:
			if body.is_in_group("craig collider") and body.get_parent().texture == load("res://textures/king_craig_vulnerable.png"):
				get_tree().current_scene.get_node("player").score += 1
			Tools.play(load("res://sound/explode.wav"))
			Tools.explode($bullet.global_position, $bullet/mesh.modulate, 0.3)
			queue_free()
		elif body.is_in_group("enemy"):
			body.health -= 1
			Tools.play(load("res://sound/explode.wav"))
			Tools.explode($bullet.global_position, Color(1.0, 0.0, 0.0), 1.0)
			queue_free()
	else:
		speed = 650.0
		if body.is_in_group("frank"):
			body.health -= 1
			Tools.play(load("res://sound/explode.wav"))
			Tools.explode($bullet.global_position, Color(1.0, 0.0, 0.0), 1.0)
			queue_free()
		elif body is StaticBody2D and !body.get_parent().name == "craig":
			Tools.play(load("res://sound/explode.wav"))
			Tools.explode($bullet.global_position, $bullet/mesh.modulate, 0.3)
			queue_free()
