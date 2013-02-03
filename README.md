restorepoint
============

Debugging in R with restore points

Abstract This package allows to debug R functions via restore points instead of break points. When called inside a function, a restore point stores all local variables. These can be restored for later debugging purposes by simply pasting the body of the function inside the R console. This vignette briefly illustrates the use of restore points and compares advantages and drawbacks compared to using break points via browser().
