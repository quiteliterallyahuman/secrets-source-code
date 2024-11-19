extends CanvasLayer


@export var text = "" ## the text to be displayed. if this changes, the text will change too and play an animation
@export var speed = 2.0 ## the speed of the animations
@export var campos = Vector2() ## the position it moves the camera to during the animation
@export var camzoom = 1.0 ## the zoom of the camera
@export var textcolour = Color.BLACK ## the colour of the text
@export var bgcolour = Color.WHITE ## the colour of the text background
@export var icon = Texture2D.new() ## the icon to be displayed
@export var sound = AudioStream.new() ## the sound to be played when it changes or becomes visible
@export var showing = true ## overrides if it is visible or not


var textprev = ""
var iconprev = CompressedTexture2D.new()
signal _continue


func _process(delta):
	$continue/button.visible = showing and text != ""
	if showing and text != "":
		if !$dialogue/camera.enabled and get_viewport().get_camera_2d():
			$dialogue/camera.global_position = get_viewport().get_camera_2d().global_position
			$dialogue/camera.zoom = get_viewport().get_camera_2d().zoom
		$dialogue/camera.zoom = lerp($dialogue/camera.zoom, Vector2(camzoom, camzoom), delta * speed * 10.0)
		$dialogue/camera.enabled = true
		$dialogue/camera.make_current()
		$dialogue/camera.global_position = campos
		$dialogue/text.visible_ratio = move_toward($dialogue/text.visible_ratio, 1.0, delta * speed)
		$dialogue/text/panel.scale.y = lerp($dialogue/text/panel.scale.y, 1.0, delta * speed * 20.0)
		$dialogue/text/panel/icon.scale = lerp($dialogue/text/panel/icon.scale, Vector2(1.0, 1.0), delta * 10.0)
	else:
		$dialogue/camera.enabled = false
		$dialogue/text.visible_ratio = move_toward($dialogue/text.visible_ratio, 0.0, delta * speed * 5.0)
		$dialogue/text/panel.scale.y = lerp($dialogue/text/panel.scale.y, 0.0, delta * 20.0)
		$dialogue/text/panel/icon.scale = lerp($dialogue/text/panel/icon.scale, Vector2(0.0, 0.0), delta * 10.0)
	$dialogue/text/panel.self_modulate = bgcolour
	$dialogue/text.label_settings.font_color = textcolour
	$dialogue/text.text = text
	$dialogue/text/panel/icon.texture = icon
	if textprev != text:
		Tools.play(sound)
		$dialogue/text.visible_ratio = 0.0
	if iconprev != icon:
		$dialogue/text/panel/icon.scale = Vector2(0.0, 1.0)
	textprev = text
	iconprev = icon

func reset_dialogue_anim():
	iconprev = CompressedTexture2D.new()
	textprev = ""


func _on_continue_pressed():
	if showing and text != "":
		emit_signal("_continue")
