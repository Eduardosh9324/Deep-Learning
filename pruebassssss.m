clear
clc
Datos = csvread('Liga_Nacional_Futbol_1976.dat',1,0);
X = Datos(:,2:5);
y = Datos(:,1);

r = 0.1;
n_epocas = 200;
p = 0.5;
n_ocultas1 = 3;
n_ocultas2 = 2;

n_ejemplos = size(X,1);
 n_entradas = size(X,2);
 
    W1 = zeros(n_entradas,n_ocultas1);
    b1 = zeros(n_ocultas1,1);
    W2 = zeros(n_ocultas1,n_ocultas2);
    b2 = zeros(n_ocultas2,1);
    W3 = zeros(n_ocultas2,1);
    b3 = zeros(1);
    
    error = zeros(n_epocas,1);
    y_predicha = zeros(length(y),1);
    for (i = 1:n_epocas)
        for (j = 1:n_ejemplos)

             aux1 = binornd(repmat(1,1,n_ocultas1),repmat(p,1,n_ocultas1));
             aux2 = binornd(repmat(1,1,n_ocultas2),repmat(p,1,n_ocultas2));
             ind1 = ajuste(aux1);
             ind2 = ajuste(aux2);
             
             drop1 = diag(aux1);
             drop2 = diag(aux2);
             
             W1d = W1*drop1;
             W2d = W2*drop2;
            
            [z2,z3,y_hat] = haciadelante(X(j,:)',y,W1d,b1,W2d,b2,W3,b3);
            delta4 = (y_hat - y(j))*z3;
            W3 = W3 - r*delta4;
            b3 = b3 - r*(y_hat - y(j));
            
            delta3 = (y_hat-y(j))*z2*W3';
            W2(:,ind2) = W2(:,ind2) - r*delta3(:,ind2);
            b2 = b2 - r*(y_hat-y(j))*W3;
            
            delta2 = (y_hat-y(j))*X(j,:)'*W3'*W2';
            W1(:,ind1) = W1(:,ind1) - r*delta2(:,ind1);
            b1 = b1 - r*(y_hat-y(j))*W2*W3;
            y_predicha(j) = y_hat;
        end
        error(i) = norm(y - y_predicha);
        err = norm(y - y_predicha);
        imprime = ['epoca = ',num2str(i),'; error = ',num2str(err)];
        disp(imprime)
    end
[y,y_predicha]