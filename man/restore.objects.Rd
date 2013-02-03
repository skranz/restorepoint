\name{restore.objects}
\alias{restore.objects}
\title{Restore stored objects by copying them into the specified environment. Is used by restore.point}
\usage{
  restore.objects(name, dest = globalenv(),
    was.forced = FALSE)
}
\arguments{
  \item{name}{name under which the variables have been
  stored}

  \item{dest}{environment into which the stored variables
  shall be copied. By default the global environment.}

  \item{was.forced}{flag whether storage of objects was
  forced. If FALSE (default) a warning is shown if
  restore.objects is called and is.storing()==FALSE, since
  probably no objects have been stored.}
}
\value{
  returns nothing but automatically copies the stored
  variables into the global environment
}
\description{
  Restore stored objects by copying them into the specified
  environment. Is used by restore.point
}

\examples{
    
}
