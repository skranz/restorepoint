\name{restore.point}
\alias{restore.point}
\title{Sets a restore point}
\usage{
  restore.point(name,
    to.global = get.restore.point.options()$to.global,
    deep.copy = get.restore.point.options()$deep.copy,
    force = FALSE,
    dots = eval(substitute(list(...), env = parent.frame())))
}
\arguments{
  \item{name}{key under which the objects are stored. For
  restore points at the beginning of a function, I would
  suggest the name of that function.}

  \item{to.global}{if TRUE (default) objects are restored
  by simply copying them into the global environment. If
  FALSE a new environment will be created and the restore
  point browser will be invoked.}

  \item{deep.copy}{if TRUE try to make deep copies of
  objects that are by default copied by reference. Works so
  far for environments (recursivly). The function will
  search lists whether they contain reference objects, but
  for reasons of speed not yet in other containers. E.g. if
  an evironment is stored in a data.frame, only a shallow
  copy will be made. Setting deep.copy = FALSE (DEFAULT)
  may be useful if storing takes very long and variables
  that are copied by reference are not used or not
  modified.}

  \item{force}{store even if set.storing(FALSE) has been
  called}

  \item{dots}{by default a list of the ... argument of the
  function in whicht restore.point was called}
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

\examples{\dontrun{
  # Check how enclosing environments are copied
  
  f = function() {
    a = 10
    i = 20
    fun = function(i) {
      restore.point("fun")
      i*a
    }
    x = lapply(3, fun)
  }
  
  g = function() {
    a = 10
    i = 20
    x = lapply(3,function(i) {
      restore.point("fun")
      i*a
    })
  }
  g()
  
  a = 5
  i = 4
  f()
  env = rpglob$OBJECTS.LIST[["fun"]]
  ls(env)
  penv = parent.env(env)
  ls(penv)
  penv$a
  parent.env(environment(fun))

  env = restorepoint:::rpglob$OBJECTS.LIST[["uheffdzusdgsf"]]
  penv = env
  penv = parent.env(penv)
  env.search = lapply(search(),as.environment)
  environmentName(penv)
  penv
  ls(penv)
  penv$a
  parent.env(environment(fun))
  

}}
