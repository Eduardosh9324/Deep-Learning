function resul = imprime(v,w,z)
for (i = 1:length(v))
    imprime = [num2str(v(i)),' & ',num2str(w(i)), ' & ',num2str(z(i)),'\\','\hline'];
    disp(imprime)
end


