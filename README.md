[![](https://cranlogs.r-pkg.org/badges/restorepoint)](https://cran.r-project.org/package=restorepoint) [![Build Status](https://travis-ci.org/skranz/restorepoint.svg?branch=master)](https://travis-ci.org/skranz/restorepoint)

Debugging R with restore points
========================================================

Author: Sebastian Kranz

Project website: https://github.com/skranz/restorepoint

Abstract:

  The package `restorepoint` allows to debug R functions via restore points instead of break points.
  When called inside a function, a restore point stores all local variables.
  These can be restored for later debugging purposes by simply copy & pasting the body of the function from the source code editor to the R console.
  This vignette briefly illustrates the use of restore points and compares advantages
  and drawbacks compared to the traditional method of setting break points via browser(). Restore points are particularly convenient when using an IDE like RStudio that allows to quickly run selected code from a script in the R Console. 

# Installation of restorepoint from Github

To install `restorepoint` from Github run the following R code:

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("skranz/restorepoint")
```

Thanks to Roman Zenka, we also plan to make a CRAN version available again sometime early 2019.

# A simple example of debugging with restore points

Consider a function `swap.in.vector` that shall split a vector at a
given position and then swap the left and right part of the vector.
Here is an example of a call to a correct implementation:

```s
swap.in.vector(1:5,3)
```

```
## [1] 3 4 5 1 2
```


Here is a faulty implementation that we want to debug:

```s
library(restorepoint)
swap.in.vector = function(vec, swap.ind) {
    restore.point("swap.in.vector", to.global = FALSE)
    left = vec[1:(swap.ind - 1)]
    right = vec[swap.ind:nrow(vec)]
    c(right, left)
}
swap.in.vector(1:10, 4)
```

```
## Error: argument of length 0
```


The first line in the function specifies a restore point. The behavior of `restore.point` depends whether it is called inside a function or directly pasted in the console.


### restore.point called inside a function

When `restore.point("some_name")` is called inside a function, it stores the
current values of all local variables under the specified name. In
the example, these local variable are `vec` and `swap.ind` and the name
is "swap.in.vector".


### restore.point is called directly in the R console

When `restore.point("swap.vector", to.global=FALSE)` is called directly in the R console, the following happens:


* The previously stored local variables are copied into a new environment
that has the global environment as enclosing environment
* The default R console is replaced by the *restore point console*.
In this console R commands are evaluated in the environment created
in the first step. To leave the restore point console and go back
to the standard R console, one just has to press ESC.

In effect, we can now debug the function by simply running line by line the source code from the function body inside the R console. If you don't use RStudio, you have to copy each line (or several lines at the same time) from your script and paste them in the R console.

With RStudio one can do that in a very convenient fashion. Just select in the source code window the lines inside the function starting with the first line that calls restore.point and press Ctrl-Enter. The marked lines will then be automatically run in the R console.

Since the call to restore.point restores the local variables to the state they have been in when restore.point has earlier been called during the function evaluation, the pasted lines of the function code (typically) behave in the same fashion as they did when the function was called the last time. We can inspect the variables and code by simply typing any desired command into the R console.





```s
  restore.point("swap.in.vector", to.global=FALSE)
```


```s
	left  = vec[1:(swap.ind-1)]
	right = vec[swap.ind:nrow(vec)]
```

```
## Error: argument of length 0
```

```s
	c(right,left)
```

```
## Error: object 'right' not found
```


The error occurred in the third line. We can inspect the variables
in more detail to narrow down the error.


```s
swap.ind
```

```
## [1] 4
```

```s
vec
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```s
swap.ind:nrow(vec)
```

```
## Error: argument of length 0
```

```s
nrow(vec)
```

```
## NULL
```


There is the culprit. The command `nrow` returns NULL for a vector.
We want to use `length(vec)` or `NROW(vec)` instead.


```s
# Try an alternative formulation
length(vec)
```

```
## [1] 10
```


We can correct the code in our script and directly test it by pasting
again the whole function body. There is no need to call the function
again, since the parameter from the previous function call are still
stored under the name ``swap.in.vector''.




Test the inside of the function by copy \& paste it into the R console.





```s
restore.point("swap.in.vector", to.global = FALSE)
```



```s
left = vec[1:(swap.ind - 1)]
right = vec[swap.ind:length(vec)]
c(right, left)
```

```
##  [1]  4  5  6  7  8  9 10  1  2  3
```


The corrected function seems to work fine so far (indeed there is
an error left that we remove in Section 3). Pressing ESC returns to
the normal evaluation mode of the R Console.


# Why I prefer restore points over break points

The standard method to debug a function is to set *break points*, yet in my experience *restore point are much more convenient*. In R break points can be set via a call to `browser()` inside the function. When during execution of the function, `browser()` is called, the R console immediately changes into an interactive debugging mode that allows to step through the code and enter any R expressions. In contrast, when `restore.point` is called inside the function there are no direct visible effects: the debugging mode starts afterward, when we decide to paste parts of the function source into the R console.

I prefer restore points over break points, mainly for the following reasons:

1. When debugging nested function calls, handling several break points can become very tedious, since the program flow is interrupted with every break point. Despite using `traceback()`, it is often not clear where exactly the error has occurred. As a consequence, I tend to set too many break points and the program flow is interrupted too often.

2. When I want to turn off invocation of the browser, I have to comment out `#browser()` and source again the function body. That can become quite tedious. When using restore points, I typically just keep the calls to `restore.point` in the code even if I may not need them at the moment. Calls to `restore.point` are simply not very obtrusive. They just make silently a copy of the data. While there is some memory overhead and execution may slow down a bit, but usually I find that negligible. I basically have a call to `restore.point` in every function, which allows me to always find out, step by step what has happened the last time some function was called.

3. I often would like to restart from the break point after I changed something in the function, to test whether the new code works. But with nested function calls, e.g. inside an optimization procedure, for which an error only occurred under certain parameter constellations, it can sometimes be quite time consuming until the state in which the error has occurred is reached again. This problem does not arise for restore points: I can always restart at the restore point and test my modified function code for the function call that caused the error.

4. The interactive browser used by browser() has a own set of command, e.q. pressing "Q" quits the browser or pressing "n" debugs the next function. For that reason, one cannot always simply copy & paste R code into the browser. (E.g. if you ) In contrast, the only special key in the debug mode of restore point is Escape, which brings you back to the standard R console. The restore point browser makes debugging via copy & paste from your R script (or in RStudio, select code and press CTRL+Enter) much easier.

5. One is automatically thrown out the debugging mode of browser() once a line with an error is pasted. This does not happen in the restore point browser. I find it much more convenient to stay in the debug mode. It allows me to paste all the code until an error has occurred and to check only afterward the values of local expressions.



# The restore point console vs restoring into global environment

Our simple example above used the call to `restore.point` with the option `to.global=FALSE`, which has the effect that future commands are evaluated in the restore point console. The main difference to the standard R console is that expressions are not evaluated in the global environment, but in an environment that emulates the local environment of the function that we want to debug.
However, by default we have `to.global = TRUE` and debugging takes a much simpler but quite dirty form. All stored objects are just copied into the global environment and the usual R console stays in place. You can test the example (make sure you have left the restore point console by pressing `Esc`).


```s
  # If to.global=TRUE or not set, objects are restored into the
  # the global environment
  restore.point("swap.in.vector")
```

```
## Restored: swap.ind,vec
```

```s
	left  = vec[1:(swap.ind-1)]
  #...
```


While this approach is quite dirty, I often prefer it for being slightly more convenient. Here are some disadvantages of the restore point console that make me often prefer the global environment approach.

* One has to press "Esc" to leave the restore point console 

* One cannot press the "Up-Arrow" key to get the previous command


On the other hand, there are several advantages of using the restore point console instead of simply copying the variables into the global environment.

* Variables in the global environment are not overwritten. This may seem a very important point. Interestingly though, in my experience, most times I debug an R program, it doesn't really matter if I overwrite global variables when restoring objects. That is because, I have all definitions of global variables in my script, which I simply run again, once I have successfully debugged the function.

* In my view more importantly, the restore point console allows to run function calls with the ellipsis, like `f(...)`. From the standard R console running a call of the form `f(...)` is not possible. (At least, I found no way to assign a value to `...` in the global environment. If somebody knows a way, please let me know.)

* If an error is caused in the restore point console, by default a stack
trace as in `traceback()` is shown.

Even though the points in favor of just using the global environment may seem small, I nevertheless typically prefer that dirty approach in my workflow and therefore made it the default.

Here are some more points that seem noteworthy.

* If you type as a single expression the function `restore.point` in the
restore point console, the corresponding objects are restored and
the restore point console changes to the corresponding environment.
This does not happen when `restore.point` is called as part of more
complex expressions inside a {...} block, e.g. inside a function, a loop,
or an if clause. Then the local objects are stored under the specified
name.

* I programmed the restore point console such that if the command source
is called, as a single command, then the restore point console automatically
quits and returns to the standard console. The reason is that I typically
source a file again, when I am finished with debugging, but I want
then automatically return to the standard R console without having
to press ESC. (In later version, this behavior may become optional).

To use the restore point console as default, you can call once `restore.point.options(to.global=FALSE)` 

# Some advice and examples on using restore.point


## When to set restore points

When writing a new function, I tend to always add a restore point
in the first line, with name equal to the function name.


```s
my.fun = function(par1, par2 = 0) {
    restore.point("my.fun")
    # ... code here ...
}
```


Unlike break points (see discussion below), restore points don't interrupt
program execution. Even though most errors are found quickly, there
are also often errors that remain hidden for a while. Therefore having
restore points in all functions can be quite convenient, in particular
in complex code: One is always prepared to debug.

One does not have to set restore points at the beginning of a function,
but can put them also somewhere else in a function. 


## Disable restore points
You can disable all restore points by calling the function `disable.restore.points()`. This removes almost all time and memory overhead of restore points. Being a lazy person, I typically just leave the calls to `restore.point` in most functions of my projects, since there always can be some reason for debugging in the future. In production, e.g. when a shiny app is initialized, I just call once at the beginning `disable.restore.points()`.

## display.restore.point and setting other global options

The function `restore.point.options` allows you to globally set different options, that can also be individually be specified in a call to `restore.point`.

I often use the following call when debugging Shiny apps:
```r
restore.point.options(display.restore.point=TRUE)
```
Then every time `restore.point` is called inside a function, a line is written to the R console with the name of the restore point. Since I have restore points in most of my functions this helps me to allocate where an error has occured. This is helpful because sometimes `traceback()` is not very precise in Shiny apps (even though there have been large improvements with newer Shiny versions.)

If you globally want to use the restore point console, instead of just copying variables in the global environment, you can call `restore.point.options(to.global=FALSE)`.

## Nested function calls

Restore points are particularly useful when debugging nested function
calls and in situations, in which errors arise only under specific
parameter constellations (possibly randomly drawn ones). Here is an
example of a faulty function that shall draw 10 times a random swap point
for a given vector and print the swapped version of the vector.


```s

# Randomly choose 10 swap points
f = function(v) {
    restore.point("f")
    for (i in 1:10) {
        rand.swap.point = sample(1:length(vec), 1)
        sw = swap.in.vector(v, rand.swap.point)
        print(sw)
    }
}

f(v = 1:5)
```

```
## [1] 4 5 1 2 3
## [1] NA NA NA  5  1  2  3  4  5 NA NA
## [1] 4 5 1 2 3
## [1] 5 1 2 3 4
## [1] 3 4 5 1 2
## [1] 1 2 3 4 5 1
## [1] NA NA NA NA  5  1  2  3  4  5 NA NA NA
## [1] 5 1 2 3 4
## [1] 2 3 4 5 1
## [1] NA NA NA  5  1  2  3  4  5 NA NA
```


The result looks strange. There is a mistake either in function f
or in swap.in.vector or in both. It is convenient to stop the execution
whenever an obviously wrong result is encountered. For this purpose,
we modify `f` by stopping execution if the length of the result is different
than the length of the original vector. We also add a restore point
with name "f.in.loop" inside the loop.


```s

# Randomly choose 10 swap points
f = function(v) {
    restore.point("f")
    for (i in 1:10) {
        rand.swap.point = sample(1:length(v), 1)
        sw = swap.in.vector(v, rand.swap.point)
        print(sw)
        restore.point("f.in.loop")
        stopifnot(length(sw) == length(v))
    }
}

set.seed(12345)
f(v = 1:5)
```

```
## [1] 4 5 1 2 3
## [1] 5 1 2 3 4
## [1] 4 5 1 2 3
## [1] 5 1 2 3 4
## [1] 3 4 5 1 2
## [1] 1 2 3 4 5 1
```

```
## Error: length(sw) == length(v) is not TRUE
```


The error may have occurred in `swap.in.vector` or in `f` or in both.
By restoring the restore point in `swap.in.vector`, we first have a
look at the parameters of the last function call before execution
has been stopped.


```s
#swap.in.vector = function(vec,swap.ind) {
	restore.point("swap.in.vector")
```

```
## Restored: swap.ind,vec
```

```s
	swap.ind
```

```
## [1] 1
```

```s
	vec
```

```
## [1] 1 2 3 4 5
```

```s
# vec has different values than the parameter v=1:5
# with which we have called f
```


We seem to call `swap.in.vector`, with a `swap.point` that is larger than
the vector. This suggests that there is an error in the function
`f`. We restore our restore point "f.in.loop" and examine the local
variables.


```s
restore.point("f.in.loop")
```

```
## Restored: i,rand.swap.point,sw,v
```

```s
v
```

```
## [1] 1 2 3 4 5
```

```s
rand.swap.point
```

```
## [1] 1
```

```s
# There must be a mistake when rand.swap.point is drawn
rand.swap.point = sample(1:length(vec), 1)
# Indeed, we use the wrong variable: vec instead of v Corrected:
rand.swap.point = sample(1:length(vec), 1)
```


It can be helpful to include a restore point within the for loop in
order to analyze the values of the local variables before the error
has been thrown.


# Known Caveats and Issues


## Variables that are passed by reference (e.g. environments)

By default restore.point does not make a deep copy of R variables that are passed by reference, like environments. However, one can set the option `deep.copy = TRUE` to make such deep copies. Although I try to make deep.copy comprehensive, e.g. searching for environments within lists, there probably will still remain some issues. Please let me know.

## Parsing multiline expressions in restore point console

So far my code for parsing multi-line expressions in the restore point console is very rough and relies on checking the text of an error message in a `tryCatch` statement. I am not sure, whether it works in all non-English versions of R. I would be very happy, if somebody knows a better solution to the problem described here:

http://stackoverflow.com/questions/13752933/parse-multiline-expressions-in-r-emulating-r-console
