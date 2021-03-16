extends VBoxContainer

export (String) var file_path_for_logfile_module = "res://LoggerTests.log"

const debug_table = """level	|verbose	|debug	|info	|warn	|error	|
verbose|	✓	|	✓	|	✓	|	✓	|	✓	|
debug  |	X	|	✓	|	✓	|	✓	|	✓	|
info   |	✗X	|	X	|	✓	|	✓	|	✓	|
warn   |	X	|	X	|	X	|	✓	|	✓	|
error  |	X	|	X	|	X	|	x	|	✓	|"""

onready var feedback_label = $RichTextLabel
const loggingProxy = preload("res://client/ExternalSinkProxy.gd")
var standart_module
var named_module
var logfile_module


func _ready() -> void:
	standart_module = Logger.get_module()

	named_module = Logger.get_module("App")
	named_module.external_sink = LoggingConsoleProxy.new("proxy", get_tree().get_root())
	named_module.output_strategies = [
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK
	]

	logfile_module = Logger.get_module("FILE")
	logfile_module.external_sink = Logger.Logfile.new("res://logs/Logger.log")
	logfile_module.output_strategies = [
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK,
		Logger.STRATEGY_EXTERNAL_SINK
	]
	print()
	print("##################################################################")
	print()


func test_cases(_loglevel, _module = null):
	if _module:
		Logger.get_module(_module).output_level = _loglevel
	else:
		Logger.get_module().output_level = _loglevel

	test_all_levels(_module)
	print("##################################################################")
	print()


func test_all_levels(_module):
	if _module:
		Logger.verbose("Verbose log!", _module)
		print("Timer started.")
		yield(get_tree().create_timer(1.0), "timeout")
		print("Timer ended.")

		Logger.debug("Debug log!", _module)
		wait(1)
		Logger.info("Info log!", _module)
		wait(1)
		Logger.warn("Warn log!", _module)
		wait(1)
		Logger.error("Error log!", _module, 3)
	else:
		Logger.verbose("Verbose log!")
		wait(1)
		Logger.debug("Debug log!")
		wait(1)
		Logger.info("Info log!")
		wait(1)
		Logger.warn("Warn log!")
		wait(1)
		Logger.error("Error log!", 3)


func _on_TestsVerbose_pressed(module) -> void:
	var module_name
	if module == 0:
		test_cases(Logger.VERBOSE)
		module_name = "Main"
	if module == 1:
		test_cases(Logger.VERBOSE, "App")
		module_name = "App"
	if module == 2:
		test_cases(Logger.VERBOSE, "FILE")
		module_name = "FILE"

	feedback_label.text += "%s verbose test done!\n" % module_name  # + debug_table 


func _on_TestsDebug_pressed(module) -> void:
	var module_name
	if module == 0:
		test_cases(Logger.DEBUG)
		module_name = "Main"
	if module == 1:
		test_cases(Logger.DEBUG, "App")
		module_name = "App"
	if module == 2:
		test_cases(Logger.DEBUG, "FILE")
		module_name = "FILE"
	feedback_label.text += "%s debug test done!\n" % module_name  # + debug_table 


func _on_TestsInfo_pressed(module) -> void:
	var module_name
	if module == 0:
		test_cases(Logger.INFO)
		module_name = "Main"
	if module == 1:
		test_cases(Logger.INFO, "App")
		module_name = "App"
	if module == 2:
		test_cases(Logger.INFO, "FILE")
		module_name = "FILE"
	feedback_label.text += "%s info test done!\n" % module_name  # + debug_table 


func _on_TestsWarn_pressed(module) -> void:
	var module_name
	if module == 0:
		test_cases(Logger.WARN)
		module_name = "Main"
	if module == 1:
		test_cases(Logger.WARN, "App")
		module_name = "App"
	if module == 2:
		test_cases(Logger.WARN, "FILE")
		module_name = "FILE"
	feedback_label.text += "%s warn test done!\n" % module_name  # + debug_table 


func _on_TestsError_pressed(module) -> void:
	var module_name
	if module == 0:
		test_cases(Logger.ERROR)
		module_name = "Main"
	if module == 1:
		test_cases(Logger.ERROR, "App")
		module_name = "App"
	if module == 2:
		test_cases(Logger.ERROR, "FILE")
		module_name = "FILE"
	feedback_label.text += "%s error test done!\n" % module_name  # + debug_table 


func _on_AutomaticTest_pressed() -> void:
	for level in range(0, 5):
		test_cases(level)
		feedback_label.text += "Main %s test done!\n" % Logger.LEVELS[level]  # + debug_table
	feedback_label.text += "All main tests done!\n\n"

	for level in range(0, 5):
		test_cases(level, "App")
		feedback_label.text += "App %s test done!\n" % Logger.LEVELS[level]
	feedback_label.text += "All app tests done!\n\n"

	for level in range(0, 5):
		test_cases(level, "FILE")
		feedback_label.text += "App %s test done!\n" % Logger.LEVELS[level]
	feedback_label.text += "All FILE tests done!\n\n"
	
func wait(sek: int):
	print("Timer started.")
	yield(get_tree().create_timer(100.0), "timeout")
	print("Timer ended.")

