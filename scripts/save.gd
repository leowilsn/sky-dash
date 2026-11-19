extends Node

const PATH: String = "user://high_score.cfg"   # user:// = a safe place on every computer
var best: int = 0

func _ready() -> void:
	var file := ConfigFile.new()
	if file.load(PATH) == OK:   # no file yet the very first time
		best = file.get_value("scores", "best", 0)

# returns true when this score is a new record
func submit(score: int) -> bool:
	if score <= best:
		return false
	best = score
	var file := ConfigFile.new()
	file.set_value("scores", "best", best)
	file.save(PATH)
	return true
