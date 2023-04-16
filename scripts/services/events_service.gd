extends Node

class_name EventsServer

func map_event(id, payload):
	if payload['type'] == 'create-room':
		create_room(id, payload)
	elif payload['type'] == 'join-room':
		join_room(id, payload)
	elif payload['type'] == 'quit-room':
		quit_room(id, payload)

func create_room(id, payload):
	var player = Server.conn_service.get_player(id)
	var room = RoomServer.new()
	player.modify_name(payload['content'])
	room.creator_id = player.player.id
	room.add_player(player)
	Server.rooms[room.creator_id] = room

	#devolver um campo de batalha, por enquanto deixar assim
	var event = {
		'type': 'created-room',
		'content': {
			'room': {
				'players': room.get_all_players_values(),
				'creator_id': room.creator_id
			}
		}
	}
	Server.send(event, id)

func join_room(id, payload):
	var player = Server.conn_service.get_player(id)
	var room_master: RoomServer = Server.rooms[int(payload['content']['roomId'])]
	player.modify_name(payload['content']['playerName'])
	room_master.add_player(player)
	
	var event_to_player_joined = {
		'type': 'update-id-after-joined-room',
		'content': {
			'id': id
		}
	}
	Server.send(event_to_player_joined, id)
	
	var event_send_all_player = {
		'type': 'joined-room',
		'content': {
			'room': {
				'players': room_master.get_all_players_values(),
				'creator_id': room_master.creator_id
			}
		}
	}
	Server.send_all(event_send_all_player, room_master.get_all_players())

func quit_room(id, payload):
	var player: Player = Server.conn_service.get_player(id)
	var room_master: RoomServer = Server.rooms[int(payload['content']['roomId'])]
	room_master.remove_player(id)
	var event = {
		'type': 'quit-other-player-room',
		'content': {
			'room': {
				'players': room_master.get_all_players_values(),
				'creator_id': room_master.creator_id
			},
			'player_quit_id': id
		}
	}
	Server.send_all(event, room_master.get_all_players())
