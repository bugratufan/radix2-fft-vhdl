function result = multi_gain(z1,z2)
% z1 = z1*16;
% z2 = z2*16;
data = complex_multip(z1,z2);
imagi = imag(data);
reali = real(data);
result = complex(reali,imagi); %complex(reali/256,imagi/256);

end

