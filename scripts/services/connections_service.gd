extends Node

class_name Connections

var players = {}

func add_player(player):
	players[int(player.player.id)] = player

func remove_player(id):
	players.erase(id)

func get_player(id):
	return players[id]

func get_all_players():
	return players
