class_name RetryUtils

const RETRY_STATUS_CODES: Array = [0, 408, 500, 502, 503, 504, 522, 524]


static func _is_retryable_status_code(status_code: int) -> bool:
	return status_code in RETRY_STATUS_CODES


static func run_http_request(request_function: Callable, retries: int = 0) -> HTTPResult:
	var response: HTTPResult = await request_function.call()
	if response == null:
		push_error("Response is null !")
		return null
	var response_code: int = response.status

	# Loop
	while _is_retryable_status_code(response_code) and retries > 0:
		push_error(
			"Request failed. Had status code [{0}]. Retrying...".format([str(response_code)])
		)
		print("Retrying... waiting for 5s...")
		await Services.timer.wait(5)
		response = await request_function.call()
		response_code = response.status
		retries -= 1

	if !response.success() or response.status_err():
		push_error("Request failed.")
		print(response)

	return response
