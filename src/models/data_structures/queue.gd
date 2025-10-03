class_name Queue

extends Object

var _data: Array = []
var _size: int = 0


# Add an item to the queue
func enqueue(item: Variant) -> void:
	_data.append(item)
	_size += 1


# Remove and return the item at the front of the queue
func dequeue() -> Variant:
	if is_empty():
		push_error("Queue is empty. Cannot dequeue.")
		return null
	_size -= 1
	return _data.pop_front()


# Peek at the front item without removing it
func peek() -> Variant:
	if is_empty():
		push_error("Queue is empty. Cannot peek.")
		return null
	return _data[0]


# Check if the queue is empty
func is_empty() -> bool:
	return _data.size() == 0


# Get the size of the queue
func size() -> int:
	return _size


# Clear the queue
func clear() -> void:
	_data.clear()
	_size = 0
