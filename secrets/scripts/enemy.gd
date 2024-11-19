extends CharacterBody2D

var time = 0.0
var spawned = true
var speed = 250.0
@onready var player = get_parent().get_node("player")
@onready var nav_agent = $nav_agent


var health = 3
var startinghealth = 3

func _physics_process(delta):
	time += delta
	if $mesh.mesh is SphereMesh:
		$mesh.rotation_degrees += delta * 50.0
		$mesh.position.y = sin(delta) * 50.0
	if player.score >= get_parent().maxpoints:
		Tools.explode(global_position, Color(1.0, 0.0, 0.0), 1.0)
		queue_free()
	if health <= 0:
		player.score += 1
		Tools.give_money(randi_range(1, startinghealth))
		queue_free()
	nav_agent.target_position = player.position
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	move_and_slide()


func _on_area_area_entered(area):
	if area.is_in_group("enemy") and spawned:
		queue_free()


func _ready():
	await get_tree().create_timer(0.05).timeout
	spawned = false
	if $mesh.mesh is SphereMesh:
		health = 1
		speed = 500.0
	startinghealth = health
