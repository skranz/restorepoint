\name{eval.with.error.trace}
\alias{eval.with.error.trace}
\title{Evals the expression such that if an error is encountered a traceback is added to the error message.}
\usage{
  eval.with.error.trace(expr, max.lines = 4,
    remove.early.calls = 0,
    error.string.fun = function(e, tb) {
        if (length(tb) > 0) {
            paste0(as.character(e), "\nCall sequence:\n", paste(tb, collapse = "\n"), "\n")
        }     else {         paste0(as.character(e), "\n")
        } })
}
\arguments{
  \item{expr}{the expression to be evaluated}

  \item{max.lines}{as in traceback()}

  \item{remove.early.calls}{an integer specifying a number
  of calls that won't be shown in the trace.}

  \item{error.string.fun}{a function(e,tb) that takes as
  arguments an error e and a string vector tb of the stack
  trace resulting from a call to calls.to.trace() and
  returns a string with the extended error message}
}
\value{
  If no error occurs the value of expr, otherwise an error
  is thrown with an error message that contains the stack
  trace of the error.
}
\description{
  This function is mostly useful within a tryCatch clause
  Adapted from code in tools:::.try_quietly as suggested by
  Kurt Hornik in the following message
  https://stat.ethz.ch/pipermail/r-devel/2005-September/034546.html
}

\examples{\dontrun{
  # A function that has an error
  f = function(x) {
    1:3[0]
  }
  g = function(x=4) {
    f(x)
  }
  # Usually no traceback is available for errors that are caught with tryCatch
  h = function() {
    tryCatch(
      g(25),
      error = identity
    )
  }
  h()
  
  # The function eval.with.error.trace adds trace information if an error is thrown
  h = function() {
    tryCatch(
      eval.with.error.trace(g(25)),
      error = identity
    )
  }
  h()
}}
