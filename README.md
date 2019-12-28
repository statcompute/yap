<p align="center">
  <img width="150" height="100" src="https://github.com/statcompute/yap/blob/master/code/yap.jpg">
</p>

### <p align="center"> Yet Another Probabilistic (YAP) </p>
### <p align="center">  Neural Network </p>

#### Introduction

YAP is a R package implementing [Probabilistic Neural Networks (Specht, 1990)](http://courses.cs.tamu.edu/rgutier/cpsc636_s10/specht1990pnn.pdf) that can be employed in N-category pattern recognition with N > 2.

Similar to General Regression Neural Networks (GRNN), PNN shares same benefits of instantaneous training, simple structure, and global convergence. 

#### Package Dependencies
R version 3.6, base, stats, parallel, randtoolbox, and lhs

#### Installation

Download the [yap_0.1.0.tar.gz](https://github.com/statcompute/yap/blob/master/yap_0.1.0.tar.gz) file, save it in your working directory, and then install the package as below.

```r
install.packages("yap_0.1.0.tar.gz", repos = NULL, type = "source")
```

#### Functions

```txt
YAP 
  |
  |-- Utility Functions
  |     |-- dummies(x)
  |     |-- folds(idx, n, seed = 1)
  |     |-- logl(y_true, y_pred)
  |     |-- gen_unifm(min = 0, max = 1, n, seed = 1)
  |     |-- gen_sobol(min = 0, max = 1, n, seed = 1)   
  |     `-- gen_latin(min = 0, max = 1, n, seed = 1) 
  |
  |-- Training
  |     `-- pnn.fit(x, y, sigma = 1) 
  |
  |-- Prediction
  |     |-- pnn.predone(net, x) 
  |     |-- pnn.predict(net, x)  
  |     `-- pnn.parpred(net, x)  
  |
  |-- Parameter Tuning
  |     |-- pnn.search_logl(net, sigmas, nfolds = 4, seed = 1) 
  |     `-- pnn.optmiz_logl(net, lower = 0, upper, nfolds = 4, seed = 1, method = 1)
  |
  `-- Variable Importance
        |-- pnn.x_imp(net, i) 
        |-- pnn.imp(net)
        |-- pnn.x_pfi(net, i, ntry = 1e3, seed = 1)
        `-- pnn.pfi(net, ntry = 1e3, seed = 1)
  
```
#### Example

Below is a demonstration showing how to use the YAP package and a comparison between the multinomial regression and the PNN. As shown below, both approaches delivered very comparable predictive performance. In this particular example, PNN even performed slightly better in terms of the cross-entropy for a separate testing dataset. 

```R
data("Heating", package = "mlogit")
Y <- Heating[, 2]
X <- scale(Heating[, 3:15])
idx <- with(set.seed(1), sample(seq(nrow(X)), nrow(X) / 2))
 
### FIT A MULTINOMIAL REGRESSION AS A BENCHMARK ###
m1 <- nnet::multinom(Y ~ ., data = data.frame(X, Y)[idx, ], model = TRUE)
# cross-entropy for the testing set
yap::logl(y_pred = predict(m1, newdata = X, type = "prob")[-idx, ], y_true = yap::dummies(Y)[-idx, ])
# 1.182727
 
### FIT A PNN ###
n1 <- yap::pnn.fit(x = X[idx, ], y = Y[idx])
parm <- yap::pnn.search_logl(n1, yap::gen_latin(1, 10, 20), nfolds = 5)
n2 <- yap::pnn.fit(X[idx, ], Y[idx], sigma = parm$best$sigma)
# cross-entropy for the testing set
yap::logl(y_pred = yap::pnn.predict(n2, X)[-idx, ], y_true = yap::dummies(Y)[-idx, ])
# 1.148456
```

