extends Control

var CONTROLLER_POLLING_VALUE = 0.5

var last_controller_poll : String
signal controller_polled

var regex = RegEx.new()

var serial := SerialPort.new()
#var port := "COM3"
var port := "COM4"
var baudrate := 9600

var is_hex := false


var input_buffer = []
var max_input_buffer = 10

var history := []
var maxHistoryEntries := 10


## TODO ## 
## This script will act as the communication / contact point from serial communication to game logic
## Essentially it should know all game systems that it needs to send serial data (controller data) too)
## Question:
## Should raw input logic (e.g. value is over a threshold we want) be here or in managers?
## Input:
## 1. "Wind" / "Shooing" system 
## 2. Plant Call / Response system
##
## Output:
## 1. Game State -> Physical plant changes

func send_input_content():
	if serial.is_open():
		if is_hex:
#			Get hex code list
			var hex_str_arr:PackedStringArray = %InputArea.text.split(" ", false)
			var hex_buf: PackedByteArray
			for hex in hex_str_arr:
				if hex.is_valid_hex_number():
#					NOTE: May be cause an error, because the hex string may large than 2 bytes.
					hex_buf.append(hex.hex_to_int())
			serial.write_raw(hex_buf)
		else:
			serial.write_str(%InputArea.text)


func update_serial():
	port = %SerialList.get_item_text(%SerialList.selected)
	serial.port = port
	baudrate = %BaudRate.get_item_text(%BaudRate.selected).to_int()
	serial.baudrate = baudrate

func _on_error(where, what):
	print_debug("Got error when %s: %s" % [where, what])


# Called when the node enters the scene tree for the first time.
func _ready():
	serial.got_error.connect(_on_error)
	var ports_info := SerialPort.list_ports()
	for info in ports_info:
		%SerialList.add_item(info)
	if ports_info.size():
		%SerialList.select(0)
		
	%BaudRate.add_item("4800")
	%BaudRate.add_item("9600")
	%BaudRate.add_item("115200")
	%BaudRate.select(1)
	
	
	update_serial()
	serial.data_received.connect(_on_data_received)
	serial.start_monitoring(20000)
	
	serial.open(port)  # NOTE: Added such that port is open right when object is created!


func _exit_tree():
	serial.stop_monitoring()

# Grab the last set of inputs (e.g. conductive mat and FSR values)
func grab_content_lines():
	var content_snapshot = %Content.text
#	var serial_start_index = content_snapshot.find("!") + 1
#	var serial_end_index = content_snapshot.find("@")
	regex.compile("\\[(.*?)\\]")
	var regex_result = regex.search(content_snapshot)
	if regex_result:
		return regex_result.get_string()
#	if result:
#		print(result.get_string()) # Would print n-0123
#	if serial_start_index > 0 and serial_end_index > 0:
#		var serial_message = content_snapshot.substr(serial_start_index, serial_end_index)
#		return serial_message
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass  # TODO: Poll controller here or on data recieved?
#	if serial.available() > 0:
#		var rec := serial.read_raw(serial.available())
#		_on_data_received(rec)
#		pass
	# Every x seconds grab the most recent 2 lines from content? use that as input?
#	await get_tree().create_timer(CONTROLLER_POLLING_VALUE).timeout 
#	var last_input = grab_content_lines()
#	# TODO: Let's do some input verification here as well
#	if last_input:
#		controller_polled.emit()
#		last_controller_poll = last_input

# the most straighforward implementation
#func add_to_buffer(data):
#	input_buffer.push_back(data)
#	while input_buffer.size() > maxHistoryEntries:
#		input_buffer.pop_front()
#	print(input_buffer)

func _on_data_received(data: PackedByteArray):
#	await RenderingServer.frame_post_draw
	%Content.text += data.get_string_from_ascii()
	%Content.scroll_vertical = %Content.get_line_count()
	if %Content.get_line_count() > 50:
		%Content.text = ""
	
	var last_input = grab_content_lines()
	# TODO: Let's do some input verification here as well
	if last_input:
		controller_polled.emit()
		self.last_controller_poll = last_input
#	if data.get_string_from_ascii().contains("*@*"):
#		print("Data from ascii: \n")
#		print(data.get_string_from_ascii())
#		print("Content text: \n")
#		print(%Content.text)
#		pass
	
#	if %Content.text.ends_with("*@*"):
#		print(%Content.text)
#		print("\n\n")
#	print(%Content.text)
#	add_to_buffer(%Content.text)
	
#	print("Received[%d]: %s" % [data.size(), data.get_string_from_ascii()])
#	if serial.is_open():
#		pass
#		serial.write_raw(data)
#		var parsed_data = data.get_string_from_ascii()
#		var serial_read_data = serial.write_raw(data)
#		print("Parsed data: " + str(parsed_data))
#		print("Serial read data: " + str(serial_read_data))
#		add_to_buffer(parsed_data)

func _on_send_pressed():
	send_input_content()


func _on_hex_toggled(button_pressed):
	is_hex = button_pressed


func _on_input_area_text_submitted(new_text):
	send_input_content()


func _on_serial_list_item_selected(index):
	port = %SerialList.get_item_text(index)


func _on_open_close_toggled(button_pressed):
	if button_pressed:
		serial.baudrate = baudrate
		serial.open(port)
		if serial.is_open():
			button_pressed = false
			%OpenClose.text = "Close"
	else:
		serial.close()
		if not serial.is_open():
			button_pressed = true
			%OpenClose.text = "Open"



func _on_baud_rate_item_selected(index):
	baudrate = %BaudRate.get_item_text(index).to_int()
	pass # Replace with function body.
