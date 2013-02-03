\name{store.objects}
\alias{store.objects}
\title{Stores all local objects of the calling environment to be able to restore them later when debugging. Is used by restore.point}
\usage{
  store.objects(name = NULL, parent.num = -1,
    deep.copy = TRUE, force = FALSE,
    store.if.called.from.global = FALSE,
    envir = sys.frame(parent.num),
    store.parent.env = "all.but.global",
    dots = eval(substitute(list(...), env = parent.frame())))
}
\arguments{
  \item{name}{key under which the objects are stored,
  typical the name of the calling function. If name is NULL
  by default the name of the calling function is chosen}

  \item{deep.copy}{if TRUE (default) variables that are
  copied by reference (in the moment environments and
  data.tables) will be stored as deep copy. May take long
  for large variables but ensures that the value of the
  stored variable do not change}

  \item{force}{store even if do.store(FALSE) has been
  called}

  \item{store.if.called.from.global}{if the function is
  called from the global environment and
  store.if.called.from.global FALSE (default) does not
  store objects when called from the global environment but
  does nothing instead.}
}
\value{
  returns nothing, just called for side effects
}
\description{
  Stores all local objects of the calling environment to be
  able to restore them later when debugging. Is used by
  restore.point
}

