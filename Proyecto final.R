### Proceso Gaussiano visto como Gibbs ###
set.seed(3456798) #Fijamos una semilla
setwd("C:/Users/lenovo/Desktop/pROYECTO2 DEEP")
## Leemos la base de datos de la liga nacional
Datos <- read.csv("Liga_Nacional_Futbol_1976.csv")

#x1<-Datos[,2]; x2<-Datos[,3]
X<-Datos[,2:3]; y<-Datos[,1]
Q<-2 #Dimensión de los vectores de muestra X
K<-10 # Número de neuronas en la capa coulta
D<-1 # Tamaño del vector de salida

## Simulamos K(X,X)
W1<-matrix(rnorm(Q*K),K, Q)
b<-rep(rnorm(K),K)

KCov<-matrix(0,length(y),length(y))
for (i in 1:length(y)) {
  for (j in 1:length(y)) {
    aux1<-0
    for (l in 1:K) {
      aux1<-aux1 + sum(X[i,]*W1[l,])*sum(X[j,]*W1[l,]) + b[l]
    }
    KCov[i,j]<-KCov[i,j] + aux1
  }
}
KCov
KCov<-KCov/K


## Simulamos de "y" tal cual el algoritmo
## en este caso, los valores y llegan a ser negativos
library(MASS)
mu <- rep(0,length(y)) # vector de medias
sigma <- KCov # matriz de covarianzas
n<-50
nn<-2*n

tau<-1000 #hiperparametro 
yy<-rep(NA,length(y))
for (dd in 1:length(y)) {
  sum<-0
      for (s in seq(1,nn,by = 2)) {
      datos <- mvrnorm(2,mu,sigma)
      W2<-matrix(rnorm(K*D),D,K)
      W1<-matrix(rnorm(Q*K),K, Q)
      sum<-sum+(1/K)*(W2%*%(W1%*%datos[1:2,dd] + rnorm(2))+rnorm(1))
      
      }
  yy[dd]<-sum
}
yy<-(yy)/tau
hist(yy,breaks = 20,freq = F)
summary(yy)

par(mfrow=c(1,2))
hist(y,main = "Datos observados",
     freq = F,breaks = 20)
hist(yy,main = "Datos simulados",
     freq = F,breaks = 20)

## Simulamos considerando solo valores positivos
tau<-1000 #hiperparametro 
yy<-rep(NA,length(y))
dd<-1
while (dd <=length(y)) {
  sum<-0
  for (s in seq(1,nn,by = 2)) {
    datos <- mvrnorm(2,mu,sigma)
    W2<-matrix(rnorm(K*D),D,K)
    W1<-matrix(rnorm(Q*K),K, Q)
    sum<-sum+(1/K)*(W2%*%(W1%*%datos[1:2,dd] + rnorm(2))+rnorm(1))
    
  }
  if(sum>0){yy[dd]<-sum;dd<-dd+1}
}
yy<-(yy)/tau
hist(yy,breaks = 20,freq = F)
summary(yy)

par(mfrow=c(1,2))
hist(y,main = "Datos observados",
     freq = F,breaks = 20)
hist(yy,main = "Datos simulados",
     freq = F,breaks = 20)
## Comparamos estadísticos básicos
## Redondemos "yy" puesto que "y" es variable tipo entero
summary(y)
summary(round(yy))

## Modelo de regresión ##
# Solo para comparar estimaciones puntuales
x1<-X[,1]; x2<-X[,2]
mod<-lm(y~x1+x2)
plot(y-mod$fitted.values,type="l")

## Intervalo bootstrap del 80%

## Considerando solo valores positivos
tau<-1000 #hiperparametro 
mm<-100
set.seed(48920415)
cuantiles<-matrix(NA,2,mm)
for (gg in 1:mm) {
yy<-rep(NA,length(y))
dd<-1
while (dd <=length(y)) {
  sum<-0
  for (s in seq(1,nn,by = 2)) {
    datos <- mvrnorm(2,mu,sigma)
    W2<-matrix(rnorm(K*D),D,K)
    W1<-matrix(rnorm(Q*K),K, Q)
    sum<-sum+(1/K)*(W2%*%(W1%*%datos[1:2,dd] + rnorm(2))+rnorm(1))
    
  }
  if(sum>0){yy[dd]<-sum;dd<-dd+1}
}
yy<-(yy)/tau
cuantiles[1:2,gg]<-c(sort(yy)[0.1*length(yy)],sort(yy)[0.9*length(yy)])
}
q1<-mean(cuantiles[1,])
q2<-mean(cuantiles[2,])
