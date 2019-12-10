function[z2,z3,y_hat] = haciadelante(x,y,W1,b1,W2,b2,W3,b3)
z2 = W1'*x + b1;
z3 = W2'*z2 + b2;
z4 = W3'*z3 + b3;
y_hat = z4;
end