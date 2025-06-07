calcAge = function(from, to) {
  age <-  as.numeric(format(to, "%Y")) - as.numeric(format(from, "%Y"))
  age <-  ifelse(as.numeric(format(to, "%m")) < as.numeric(format(from, "%m"))
                 | (as.numeric(format(to, "%m")) == as.numeric(format(from, "%m"))
                    & as.numeric(format(to, "%m")) < as.numeric(format(from, "%m"))),
                 age - 1,
                 age)
  return(age);
}

calcIMT <- function(weight, height) { 
  res <- weight / (height ^ 2)
  return (res)
}