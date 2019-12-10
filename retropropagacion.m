function [W1,W2,W3,error,y_predicha] = retropropagacion(X,y,r,n_epocas,n_ocultas1,n_ocultas2,p)
 n_ejemplos = size(X,1);
 n_entradas = size(X,2);
 %Definimos los valores iniciales
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
             %Generamos un vector de bernoullis con valor parametral p
             aux1 = binornd(repmat(1,1,n_ocultas1),repmat(p,1,n_ocultas1));
             aux2 = binornd(repmat(1,1,n_ocultas2),repmat(p,1,n_ocultas2));
             ind1 = ajuste(aux1);
             ind2 = ajuste(aux2);
             %Creamos una matriz diagonal con el vector de bernoullis
             drop1 = diag(aux1);
             drop2 = diag(aux2);
             %Definimos que neuronas se apagan y que se encienden con la
             %multiplicacion matricial
             W1d = W1*drop1;
             W2d = W2*drop2;
            %Pasamos por la funcion haciadelante para hacer el calculo
            [z2,z3,y_hat] = haciadelante(X(j,:)',y,W1d,b1,W2d,b2,W3,b3);
            delta4 = (y_hat - y(j))*z3;
            W3 = W3 - r*delta4;
            b3 = b3 - r*(y_hat - y(j));
            %Actualizamos las entradas de las matrices correspondientes
            delta3 = (y_hat-y(j))*z2*W3';
            W2(:,ind2) = W2(:,ind2) - r*delta3(:,ind2);
            b2 = b2 - r*(y_hat-y(j))*W3;
            
            delta2 = (y_hat-y(j))*X(j,:)'*W3'*W2';
            W1(:,ind1) = W1(:,ind1) - r*delta2(:,ind1);
            b1 = b1 - r*(y_hat-y(j))*W2*W3;
            y_predicha(j) = y_hat;
        end
        error(i) = sum((y - y_predicha).^2)/(2*n_ejemplos);
        err = norm(y - y_predicha);
        imprime = ['epoca = ',num2str(i),'; error = ',num2str(err)];
        disp(imprime)
    end
end


            
            
    
    
    
    
    
    