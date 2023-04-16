extends Node

class_name Util

func _ready():
	randomize()
	
static func random_integer_between_two_numbers(minimum, maximum):
	return randi() % maximum + minimum

static func random_transform():
	return {
		'x': random_integer_between_two_numbers(500, 4500),
		'y': random_integer_between_two_numbers(500, 4500),
		'rotation': random_integer_between_two_numbers(1, 360)
	}
