extends Node
class_name WS_LoggingClient


export var port: int = 6624
const protocols: PoolStringArray = PoolStringArray(["binary"])
var websocket_url = "ws://localhost:%s" % port

var wsc: WebSocketClient


func _ready() -> void:
	wsc = WebSocketClient.new()

	wsc.connect("connection_established", self, "_on_connection_established")
	wsc.connect("connection_closed", self, "_on_connection_closed")
	wsc.connect("connection_error", self, "_on_connection_error")
	wsc.connect("server_close_request", self, "_on_close_request")

	connect_to_server()

func _process(_delta: float) -> void:
	wsc.poll()

func send_log(output, level: int):
	var log_msg = {
		"level": level,
		"msg": output,
	}
	_send_message(to_json(log_msg))

func _send_message(msg: String)-> bool:
	var result = wsc.get_peer(1).put_packet(msg.to_utf8())
	if result == OK:
		print("Send msg!")
		return true
	else:
		print("Could not send msg! Error: %s" % result)
		return false
	
func connect_to_server():
	var result = wsc.connect_to_url(websocket_url)
	print("Trying to connect to %s" % websocket_url)
	if result == OK:
		print("Connected to %s" % websocket_url)
		return
	else:
		print("Could not connect to Server reason: %s" % result)
		return

func _on_connection_established(protocol: String):
	print("Connected with %s" % protocol)
	print("%s:%s" % [wsc.get_connected_host(), wsc.get_connected_port()])

func _on_connection_closed(was_clean_close: bool):
	print("Connection closed. was disconected cleanly: %s" % was_clean_close)

func _on_connection_error():
	print("Could not connect to Server at: %s" % websocket_url)

func _on_close_request(code: int, reason: String):
	wsc.disconnect_from_host()

