extends Node

class_name Player

var player = {}

func _ready():
	randomize()

func modify_name(name):
	player['name'] = name
	return self

func modify_transform(transform):
	player['transform'] = transform
	return self

func modify_life(life):
	player['life'] += life
	return self

func create(id):
	player = {
		'id': id,
		'name': '-',
		'transform': Util.random_transform(),
		'life': 100
	}
	return self
