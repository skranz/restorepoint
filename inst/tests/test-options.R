test_that("get options does not fail", {
	optionNames <- sort(names(get.restore.point.options()))
	expect_equal(optionNames, c(
				    "break.point.to.global", 
				    "deep.copy", 
				    "display.restore.point", 
				    "multi.line.parse.error",
				    "storing",
				    "to.global", 
				    "trace.calls")) 
});

test_that("options can be set", {
	old <- get.restore.point.options()[["deep.copy"]]
	set.restore.point.options(deep.copy = TRUE)
	new <- get.restore.point.options()[["deep.copy"]]	
	expect_equal(old, FALSE)
	expect_equal(new, TRUE)
	set.restore.point.options(deep.copy = old)
})
