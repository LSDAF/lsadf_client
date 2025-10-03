class_name HttpEventHandler
extends Node

const RETRY_DELAY: int = 5

var _queue: Queue
var _prioritary_queue: Queue


func process_queue(prioritary: bool) -> void:
	var queue_to_process: Queue = _prioritary_queue if prioritary else _queue
	while not queue_to_process.is_empty():
		var event: HttpEvent = queue_to_process.dequeue()
		var result: bool = _process_event(event)
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

	var final_result: bool = false

	for i in range(nb_tries):
		callable.call()
	# waits for 5 seconds before retrying

	return true


func _init(queue: Queue, prioritary_queue: Queue) -> void:
	_queue = queue
	_prioritary_queue = prioritary_queue
