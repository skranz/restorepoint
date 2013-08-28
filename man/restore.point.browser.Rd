\name{restore.point.browser}
\alias{restore.point.browser}
\title{Examing a restore point by invoking the browser}
\usage{
  restore.point.browser(name, was.forced = FALSE,
    message.text = paste("restore point", name, ", press ESC to return."),
    deep.copy = get.restore.point.options()$deep.copy)
}
\arguments{
  \item{name}{name under which the variables have been
  stored}

  \item{was.forced}{flag whether storage of objects was
  forced. If FALSE (default) a warning is shown if
  restore.objects is called and is.storing()==FALSE, since
  probably no objects have been stored.}

  \item{message.text}{initial shown message}

  \item{deep.copy}{when storing or restoring tries to make
  a deep copy of R objects that are by default copied by
  reference, like environments. Setting deep.copy = FALSE
  can substantially speed up restore.point, however.}
}
\value{
  returns nothing
}
\description{
  Examing a restore point by invoking the browser
}

