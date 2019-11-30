pnn.fit <- function(x, y, sigma = 1) {
  ### CHECK X MATRIX ###
  if (is.matrix(x) == F) stop("x needs to be a matrix.", call. = F)
  if (anyNA(x) == T) stop("NA found in x.", call. = F)
  ### CHECK Y VECTOR ###
  if (is.vector(y) == F) stop("y needs to be a vector.", call. = F)
  if (anyNA(y) == T) stop("NA found in y.", call. = F)
  if (length(y) != nrow(x)) stop("x and y need to share the same length.", call. = F)
  ### CHECK SIGMA ###
  if (sigma <= 0) stop("sigma needs to be positive", call. = F)

  pn <- structure(list(), class = "Probabilistic Neural Net")
  pn$x <- x
  pn$y.raw <- y
  pn$y.ind <- dummies(y)
  pn$sigma <- sigma
  return(pn)
}
