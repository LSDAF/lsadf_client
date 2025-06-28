extends GutTest

var queue: Queue


func before_each() -> void:
	queue = Queue.new()


# Test enqueue operation
func test_enqueue() -> void:
	queue.enqueue(1)
	queue.enqueue(2)
	queue.enqueue(3)
	assert_eq(queue.size(), 3, "Queue size should be 3")
	assert_eq(queue.peek(), 1, "First item in the queue should be 1")


# Test dequeue operation
func test_dequeue() -> void:
	queue.enqueue(1)
	queue.enqueue(2)
	queue.enqueue(3)
	var item: Variant = queue.dequeue()
	assert_eq(item, 1, "Dequeued item should be 1")
	assert_eq(queue.size(), 2, "Queue size should be 2 after dequeue")
	assert_eq(queue.peek(), 2, "First item in the queue should now be 2")


# Test is_empty()
func test_is_empty() -> void:
	assert_eq(queue.is_empty(), true, "Queue should initially be empty")
	queue.enqueue(1)
	assert_false(queue.is_empty(), "Queue should not be empty after enqueue")


# Test peek operation
func test_peek() -> void:
	queue.enqueue("test")
	assert_eq(queue.peek(), "test", "Peeked value should be 'test'")
	queue.dequeue()
	assert_eq(queue.is_empty(), true, "Queue should be empty after dequeue")


# Test clear operation
func test_clear() -> void:
	queue.enqueue(1)
	queue.enqueue(2)
	queue.clear()
	assert_eq(queue.is_empty(), true, "Queue should be empty after clear")
	assert_eq(queue.size(), 0, "Queue size should be 0 after clear")


# Test dequeue on an empty queue
func test_dequeue_empty() -> void:
	var item: Variant = queue.dequeue()
	assert_eq(item, null, "Dequeuing an empty queue should return null")


# Test peek on an empty queue
func test_peek_empty() -> void:
	var item: Variant = queue.peek()
	assert_eq(item, null, "Peeking an empty queue should return null")
