function indices = ajuste(v)
i = 1;
indices = [];
while (i<=length(v))
    if(v(i)==1)
        indices = [indices,i];
    end
    i = i + 1;
end
end