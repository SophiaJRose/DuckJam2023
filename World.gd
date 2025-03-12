extends Node

var colours = [
	"#ff6347",
	"#ff8c00",
	"#adff2d",
	"#32cb32",
	"#3fe0d1",
	"#3f68e0",
	"#a021ef",
	"#ed81ed",
	"#ff68b5"
]
var usedColours = []

@onready var groundNodes = get_tree().get_nodes_in_group("Ground")
@onready var pedestalNodes = get_tree().get_nodes_in_group("Pedestal")
@onready var bridgeNodes = get_tree().get_nodes_in_group("Bridge")
@onready var towerNodes = get_tree().get_nodes_in_group("Tower")
@onready var wallNodes = get_tree().get_nodes_in_group("Wall")
@onready var ledgeNodes = get_tree().get_nodes_in_group("Ledge")

@onready var allNodes = [
	groundNodes,
	pedestalNodes,
	bridgeNodes,
	towerNodes,
	wallNodes,
	ledgeNodes
]

func _ready():
	randomize()
	for nodeSet in allNodes:
		var colourIndex = randi() % colours.size()
		while colourIndex in usedColours:
			colourIndex = randi() % colours.size()
		usedColours.append(colourIndex)
		var colour = colours[colourIndex]
		for node in nodeSet:
			var material
			if node is MeshInstance3D:
				material = node.get_active_material(0)
			else:
				material = node.get_material()
			if material is StandardMaterial3D:
				material.albedo_color = Color(colour)
