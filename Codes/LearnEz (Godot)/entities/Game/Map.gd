extends Area2D

const N = 1
const E = 2
const S = 4
const W = 8

onready var numOfEnemies = enemyloc.size()
onready var questionPopup = get_parent().get_node("Questions")

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, Vector2(0, 1): S, Vector2(-1, 0): W}

var tile_size = 64
var width = 16
var height = 9
var enemyloc = []

onready var EnemySprite = $Sprite
onready var Map = $TileMap
onready var Player = get_parent().get_node("Player")

func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()
	generate_enemies()
		
func _physics_process(delta):
	if enemyloc.size() == 0:
		set_physics_process(false)
		pass
	var pos = Player.get_position()
	var tile = Map.world_to_map(pos)
	for k in enemyloc:
		if (tile == k):
			questionPopup.popup()
			get_parent().get_node("TimerPopup").popup()
			enemyloc.remove(enemyloc.bsearch(k))
			var children = get_children()
			for c in children:
				if c is StaticBody2D:
					if Map.world_to_map(c.position) == tile:
						remove_child(c)
			numOfEnemies = enemyloc.size()

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []
	var stack = []
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	pass
	 
func shuffleList(list):
    var shuffledList = []  
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func make_enemy(k):
	var item = preload("res://bug.png")
	var node = StaticBody2D.new()
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(64,64))
	var sprite = Sprite.new()
	var pos = Map.map_to_world(k)
	pos += Vector2(32,32)
	node.set_position(pos)
	node.add_child(sprite)
	sprite.texture = item
	node.set_name("Enemy" + str(k))
	add_child(node)
	
func generate_enemies():
	var nodelist = []
	for x in width:
		for y in height:
			nodelist.append(Vector2(x,y))
	nodelist.pop_front()
	for x in range(6):
		nodelist = shuffleList(nodelist)
		var pos = nodelist.pop_front()
		enemyloc.append(pos)
	for k in enemyloc:
		make_enemy(k)
	enemyloc.sort()
