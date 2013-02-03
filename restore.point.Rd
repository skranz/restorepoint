\name{restore.point}
\alias{restore.point}
\title{Sets a restore point}
\usage{
  restore.point(name, exclude = NULL, clone = TRUE,
    force = FALSE)
}
\arguments{
  \item{name}{key under which the objects are stored. For
  restore points at the beginning of a function, I would
  suggest the name of that function.}

  \item{exclude}{names of variables that shall not be
  stored}

  \item{clone}{if TRUE (default) all objects that are
  environments will be cloned. This may take long but
  ensures that the value of the stored variable do not
  change}

  \item{force}{store even if do.store(FALSE) has been
  called}
}
\description{
  The function behaves different when called from a
  function or when called from the global environemnt. When
  called from a function, it makes a backup copy of all
  local objects and stores them internally under a key
  specified by name. When called from the global
  environment, it restores the previously stored objects by
  copying them into the global environment. See the package
  Vignette for an illustration of how this function can
  facilitate debugging.
}

\examples{
  library(restorepoint)
  # A function that swaps the left and right part of a vector
  swap.in.vector = function(vec,swap.ind) {
    restore.point("swap.in.vector")
    
    left  = vec[1:(swap.ind-1)]
    right = vec[swap.ind:length(vec)]
    c(right,left)
  }
  swap.in.vector(1:10,4)
  
  # Paste first two lines of the function
  restore.point("swap.in.vector")
  left  = vec[1:(swap.ind-1)]
  
  # Investigate
  left
  
  
  # Call the function from within another function
  f = function(vec=1:5) {
    for (i in 1:20) {
      swap.point = sample(1:length(vec),1)                    
      sw = swap.in.vector(vec,swap.point)
      print(sw)
      if (length(sw)>length(vec))
        stop("Error output too long...")
    }
  }

}

