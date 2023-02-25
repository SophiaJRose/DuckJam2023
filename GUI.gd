extends MarginContainer

onready var timerLabel = get_node("VBoxContainer/TimerLabel")

func _process(delta):
	timerLabel.text = "Timer: " + str(GlobalVariables.deathTimer)
