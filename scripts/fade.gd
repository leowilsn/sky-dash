extends CanvasLayer

@onready var black: ColorRect = $Black
var busy: bool = false   # true while a fade is running

func change_scene(path: String) -> void:
	if busy:
		return   # already changing scene - ignore a second call
	busy = true
	# 1. fade to black in 0.4 s
	var tween: Tween = create_tween()
	tween.tween_property(black, "modulate:a", 1.0, 0.4)
	await tween.finished
	# 2. swap the scene while the screen is black
	get_tree().change_scene_to_file(path)
	# 3. fade back in
	var tween2: Tween = create_tween()
	tween2.tween_property(black, "modulate:a", 0.0, 0.4)
	await tween2.finished
	busy = false
