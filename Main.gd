extends Node2D

# CONSTANTS
#==================================================================================================#
const SERVER_IP = "ws://127.0.0.1:"
const SERVER_PORT = 6969
const MAX_CONNECTIONS = 4
#==================================================================================================#

# MEMBER VARIABLES
#==================================================================================================#
var _serverButton
var _clientButton
onready var _server_peer = WebSocketServer.new()
onready var _client_peer = WebSocketClient.new()
var _err = OK #error tracker
onready var _num_of_clients_connected = 0
onready var _accepting_new_connections = true
onready var _connected_client_ids = "\n"
#==================================================================================================#

# GODOT BUILT IN FUNCTIONS
#==================================================================================================#
func _ready():
	_serverButton = get_node("Button_Server")
	_clientButton = get_node("Button_Client")
	_serverButton.connect("pressed", self, "_establish_server")
	_clientButton.connect("pressed", self, "_client_connect")
	_err += get_tree().connect("network_peer_connected", self, "_client_connected")
	if _err != OK:
		print("signal connection failure")

func _process(_delta):
	if _server_peer.is_listening():
		$Label.text = \
			"Number of clients connected: " + str(_num_of_clients_connected) + _connected_client_ids
		return
	var status = _client_peer.get_connection_status()
	if (status == NetworkedMultiplayerPeer.CONNECTION_CONNECTED):
		$Label.text = "Connected at " + SERVER_IP + str(SERVER_PORT)
	if (status == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		$Label.text = "Trying connection"
	if (status == NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED):
		$Label.text = "No connection"
#==================================================================================================#

# MEMBER FUNCTIONS
#==================================================================================================#
func _client_connected(client_id):
	_num_of_clients_connected += 1
	_connected_client_ids += "Client[" + str(_num_of_clients_connected) + "]" + " id:" + \
		str(client_id) + "\n"

func _establish_server():
	_err = _server_peer.listen(SERVER_PORT, PoolStringArray(), true)
	if _err != OK:
		print("Server cannot be established")
	get_tree().set_network_peer(_server_peer)

func _client_connect():
	_err = _client_peer.connect_to_url(SERVER_IP + str(SERVER_PORT), PoolStringArray(), true)
	get_tree().set_network_peer(_client_peer)
#==================================================================================================#
