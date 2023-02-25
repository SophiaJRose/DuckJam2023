extends Node

export var spawnPositions = [
	Vector3(15, 1.5, 15),
	Vector3(-15, 1.5, 15),
	Vector3(-15, 1.5, -15),
	Vector3(15, 1.5, -15)
]
onready var orb = get_node("Orb")
var position = -1
var spawnTimer = 0

func _ready():
	randomize()
	position = randi() % spawnPositions.size()
	orb.translation = spawnPositions[position]
	print("Orb spawned at " + String(orb.translation))

func _process(delta):
	if spawnTimer >= 0:
		spawnTimer -= 1
	if spawnTimer == 0:
		orb.collision_layer = 4
		var newPosition = position
		while newPosition == position:
			newPosition = randi() % spawnPositions.size()
		position = newPosition
		orb.translation = spawnPositions[position]
		print("Orb spawned at " + String(orb.translation))

func _on_Player_orbCollected():
	orb.collision_layer = 0
	orb.translation = Vector3(0, -10, 0)
	spawnTimer = 5
