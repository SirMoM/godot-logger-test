extends Node
class_name LoggingConsoleProxy

# Queue modes
const QUEUE_NONE = 0
const QUEUE_ALL = 1
const QUEUE_SMART = 2


var _client: WS_LoggingClient
var queue_mode = QUEUE_NONE
var buffer = PoolStringArray()
var buffer_idx = 0

func _init(_name, _root, _queue_mode = QUEUE_NONE).() -> void:
	name = _name
	queue_mode = _queue_mode
	
	_client = WS_LoggingClient.new()
	_root.call_deferred("add_child", _client)

func flush_buffer():
	"""Flush the buffer, i.e. write its contents to the target external sink."""
	print("[ERROR] [logger] Using method which has to be overriden in your custom sink")

func write(output, level):
	"""Write the string at the end of the sink (append mode), following
	the queue mode."""
	_client.send_log(output, level)
	
func set_queue_mode(new_mode):
	queue_mode = new_mode

func get_queue_mode():
	return queue_mode
	
func get_name():
	return name

func get_config():
	return {
		"queue_mode": get_queue_mode(),
	}
