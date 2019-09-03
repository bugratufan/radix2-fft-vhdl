clc
clear all
close all

fileID = fopen('C:\Users\bugra\Desktop\Yonga\FFT\VHDL\version-pipeline\input_vectors.txt','w');

t = 0:1/32:0.49;

%% S1
x = sin(2*pi*t*10) + sin(2*pi*t*7);


for a=0:15
    %disp("....................."+num2str(a));
    disp("X"+num2str(a)+" <= """ + dec2bin(typecast(single(x(1,a+1)),'uint32'),32)+""";" );
    fprintf(fileID, dec2bin(typecast(single(x(1,a+1)),'uint32'),32)+"\n");
end
