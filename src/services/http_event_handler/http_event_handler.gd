class_name HttpEventHandler
extends Node

var _queue: Queue
var _prioritary_queue: Queue
var _timer: TimerService


func process_queue(prioritary: bool) -> void:
	var queue_to_process: Queue = _prioritary_queue if prioritary else _queue
	while not queue_to_process.is_empty():
		var event: HttpEvent = queue_to_process.dequeue()
		var result: bool = await _process_event(event)
		if result:
			print("Function called successfully.")
			break
		else:
			print("Error while calling the function.")


func enqueue_event(http_event: HttpEvent) -> void:
	if http_event.get_prioritary():
		_prioritary_queue.enqueue(http_event)
	else:
		_queue.enqueue(http_event)


func _process_event(http_event: HttpEvent) -> bool:
	var callable: Callable = http_event.get_function()
	var nb_tries: int = http_event.get_nb_tries()

	var result: bool = await callable.call()

	var try: int = 1

	while result == false and try <= nb_tries:
		print("Result is false, retrying in " + str(try) + "s...")
		await _timer.wait(try)
		try += 1
		result = await callable.call()

	if (result):
		print("Result is true")
		return result

	print("No retry left, result false")
	return result


func _init(queue: Queue,
			prioritary_queue: Queue,
			timer: TimerService) -> void:
	_queue = queue
	_prioritary_queue = prioritary_queue
	_timer = timer
