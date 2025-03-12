extends Node

@export var survivalTimer = 0
@export var deathTimer = -1
@export var deathTimerMax = 4500
@export var deathTimerMoveDec = 2
@export var deathTimerStatDec = 10
@export var retryText = ""

func _process(_delta):
	deathTimerMoveDec = 2 + (survivalTimer / 1800)
	deathTimerStatDec = 5 * deathTimerMoveDec
