extends Node

var server = WebSocketServer.new()
var conn_service = Connections.new()
var events_service = EventsServer.new()
var rooms = {}

var port = 4000
#var host = '191.101.71.248'
var host = '127.0.0.1'

func _ready():
	server.connect("client_connected", self, "client_connected")
	server.connect("client_disconnected", self, "client_disconnected")
	server.connect("data_received", self, "data_received")
	start_server()

func start_server():
	server.bind_ip = host
	server.listen(port)
	print('servidor iniciado na porta {port} e host {host}'.format({ 'port': port, 'host': host }))

func _process(delta):
	server.poll()

func client_connected(id):
	var player = Player.new()
	conn_service.add_player(player.create())
	print('\n cliente conectou com id: ', id)

func client_disconnected(id, was_clean_close):
	conn_service.remove_player(id)
	rooms.erase(id)
	print('\n desconectou corretamente: ', was_clean_close)

func data_received(id):
	if !(id in conn_service.players):
		var player = Player.new()
		conn_service.add_player(player.create(id))

	var payload = JSON.parse(server.get_peer(id).get_packet().get_string_from_utf8()).result
	events_service.map_event(id, payload)

func send(data, id):
	server.get_peer(id).put_packet(JSON.print(data).to_utf8())

func send_all(data, list):
	for id in list:
		Server.send(data, id)
