extends MarginContainer

onready var timerLabel = get_node("VBoxContainer/TimerLabel")
onready var timerBar = get_node("VBoxContainer/TimerBarBG/TimerBar")
onready var retryLabel = get_node("VBoxContainer/RetryLabel")

func _process(_delta):
	retryLabel.text = GlobalVariables.retryText
	timerLabel.text = ("%02d" % (GlobalVariables.survivalTimer / 3600)) + ":" + ("%02d" % ((GlobalVariables.survivalTimer / 60) % 60))
	if GlobalVariables.deathTimer == -1:
		timerBar.rect_scale.x = 1
		timerBar.color = Color(0.875, 0.875, 0.875)
	else:
		var deathTimerPercent = float(GlobalVariables.deathTimer) / float(GlobalVariables.deathTimerMax)
		timerBar.rect_scale.x = deathTimerPercent
		timerBar.color = Color(0.875, clamp(1.75 * deathTimerPercent, 0, 0.875), clamp(1.75 * deathTimerPercent, 0, 0.875))
