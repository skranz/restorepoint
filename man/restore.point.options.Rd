\name{restore.point.options}
\alias{restore.point.options}
\title{Set and retrieve global options for restore points}
\usage{
  restore.point.options(options = NULL, ...)
}
\arguments{
  \item{options}{a list of options that shall be set.
  Possible options are listed below}

  \item{storing}{TRUE / FALSE enable or disable storing of
  options, setting storing = FALSE basicially turns off
  debugging via restore points}

  \item{use.browser}{TRUE/FALSE If FALSE (default), when
  options are restored they are simply copied into the
  global environment and the R console is directly used for
  debugging. If TRUE a browser mode will be started when
  objects are restored. It is still possible to parse all R
  commands into the browser and to use copy and paste. To
  quit the browser press ESC in the R console. The
  advantage of the browser is that all objects are stored
  in a newly generated environment that mimics the
  environemnt of the original function, i.e. global
  varariables are not overwritten. Furthermore in the
  browser mode, one can pass the ... object to other
  functions, while this does not work in the global
  environment. The drawback is that at least on my computer
  the approach does not currently work under RStudio, which
  crashes when it is attempted to parse a command from the
  console using the parse() command.}
}
\description{
  Set and retrieve global options for restore points
}

