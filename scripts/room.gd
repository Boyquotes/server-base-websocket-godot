extends Node

class_name RoomServer

var players = {}
var items = []

var creator_id = null
var max_players = 10

func _ready():
	randomize()

func add_player(player):
	players[int(player.player.id)] = player

func remove_player(id):
	players.erase(id)

func get_player(id):
	return players[int(id)]

func get_all_players_values():
	var players_values = []
	for i in players:
		players_values.append(players[i].player)
	return players_values

func get_all_players():
	return players
