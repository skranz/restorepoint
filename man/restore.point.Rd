\name{restore.point}
\alias{restore.point}
\title{Sets a restore point}
\usage{
  restore.point(name, deep.copy = TRUE, force = FALSE,
    dots = eval(substitute(list(...), env = parent.frame())),
    to.global = get.restore.point.options()$to.global)
}
\arguments{
  \item{name}{key under which the objects are stored. For
  restore points at the beginning of a function, I would
  suggest the name of that function.}

  \item{deep.copy}{if TRUE (default) try to make deep
  copies of objects that are by default copied by
  reference. Works so far for environments (recursivly) and
  data.tables. The function will search lists whether they
  contain reference objects, but for reasons of speed not
  yet in other containers. E.g. if an evironment is stored
  in a data.frame, only a shallow copy will be made.
  Setting deep.copy = FALSE may be useful if storing takes
  very long and variables that are copied by reference are
  not used or not modified.}

  \item{force}{store even if set.storing(FALSE) has been
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

