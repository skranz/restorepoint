\name{env.console}
\alias{env.console}
\title{Emulates an R console that evaluates expressions in the specified environement env. You return to the standard R console by pressing ESC}
\usage{
  env.console(env = new.env(parent = parent.env),
    parent.env = parent.frame(), dots = NULL,
    prompt = ": ",
    startup.message = "Press ESC to return to standard R console")
}
\arguments{
  \item{The}{environment in which expressions shall be
  evaluated. If not specified then a new environment with
  the given parent.env is created.}

  \item{If}{env is not specified the parent environemnt in
  which the new environment shall be created}

  \item{dots}{a list that contains values for the ellipsies
  ... that will be used if you call other functions like
  fun(...) from within the console. You can access the
  values inside the console by typing list(...)}

  \item{prompt}{The prompt that shall be shown in the
  emulated console. Default = ": "}
}
\value{
  Returns nothing since the function must be stopped by
  pressing ESC.
}
\description{
  Emulates an R console that evaluates expressions in the
  specified environement env. You return to the standard R
  console by pressing ESC
}

\examples{

  # Generate an environment and start a console that can be used to evaluate 
  # that environment
  a = 5
  env = new.env()
  env$b = "Hi"
  env.console(env=env, dots = list("A"="ABC"))
  
  # Investigate the environment of the function
  f = function(a,b="B",...) {
    env.console(environment(), dots=list(...))
  }
  f(a=5,c=10,d=20)
  # Try typing list(...) in the new console
}
