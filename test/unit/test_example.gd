extends GutTest
func before_each() -> void:
	gut.p("ran setup", 2)

func after_each() -> void:
	gut.p("ran teardown", 2)

func before_all() -> void:
	gut.p("ran run setup", 2)

func after_all() -> void:
	gut.p("ran run teardown", 2)

func test_assert_eq_number_not_equal() -> void:
	assert_eq(1, 2, "Should fail.  1 != 2")

func test_assert_eq_number_equal() -> void:
	assert_eq('asdf', 'asdf', "Should pass")

func test_assert_true_with_true() -> void:
	assert_true(true, "Should pass, true is true")

func test_assert_true_with_false() -> void:
	assert_true(false, "Should fail")

func test_something_else() -> void:
	assert_true(false, "didn't work")
