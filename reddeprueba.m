% RED
clear
clc
Datos = csvread('Liga_Nacional_Futbol_1976.dat',1,0);
X = Datos(:,2:3);
y = Datos(:,1);
alpha = 1; %0.01

%Optimizamos la red con 80 epocas,10 neuronas ocultas, un valor p=0.5 en 
%la probabilidad de las capas con dropout
[W1,W2,W3,error,y_predicha] = retropropagacion(X,y,alpha,80,10,1,0.5)
figure(1)
plot(error,'-o')
title(['alpha = ',num2str(alpha)])
xlabel('epocas')
ylabel('error')

figure(2)
plot(1:28,y-y_predicha,'-o',[0 30],[0 0])
title(['alpha = ',num2str(alpha)])
xlabel('ejemplos')
ylabel('y - y_hat')

[y,y_predicha]
