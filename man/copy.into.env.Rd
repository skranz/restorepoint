\name{copy.into.env}
\alias{copy.into.env}
\title{Copies all members of a list or environment into an environment}
\usage{
  copy.into.env(source = sys.frame(sys.parent(1)),
    dest = sys.frame(sys.parent(1)), names = NULL,
    exclude = NULL)
}
\arguments{
  \item{source}{a list or environment from which objects
  are copied}

  \item{dest}{the environment into which objects are
  copied}

  \item{names}{optionally a vector of names that shall be
  copied. If null all objects are copied}

  \item{exclude}{optionally a vector of names that shall
  not be copied}
}
\description{
  Copies all members of a list or environment into an
  environment
}

