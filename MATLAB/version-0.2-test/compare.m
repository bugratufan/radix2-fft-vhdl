clc;
clear all;
close all;

t = 0:1/32:0.49;

fid = fopen('C:\Users\bugra\Desktop\Yonga\FFT\VHDL\version-pipeline\output_results.txt');
vhdl_out = zeros(16,1);

for a = 0:15
    line_ex = fgetl(fid);  % read line excluding newline character
    hex_str = dec2hex(bin2dec(line_ex));
    real_part = typecast(uint32(hex2dec(hex_str)),'single');
    
    line_ex = fgetl(fid);  % read line excluding newline character
    hex_str = dec2hex(bin2dec(line_ex));
    imag_part = typecast(uint32(hex2dec(hex_str)),'single');
    
    vhdl_out(a+1,1) = complex(real_part,imag_part);
end


%reorder
module(1) = vhdl_out(1);
module(2) = vhdl_out(9);
module(3) = vhdl_out(5);
module(4) = vhdl_out(13);
module(5) = vhdl_out(3);
module(6) = vhdl_out(11);
module(7) = vhdl_out(7);
module(8) = vhdl_out(15);
module(9) = vhdl_out(2);
module(10) = vhdl_out(10);
module(11) = vhdl_out(6);
module(12) = vhdl_out(14);
module(13) = vhdl_out(4);
module(14) = vhdl_out(12);
module(15) = vhdl_out(8);
module(16) = vhdl_out(16);

figure,

 x = sin(2*pi*t*10) + sin(2*pi*t*7);

data = abs(fft(x));
subplot(3,1,1);
plot(t,data);
xlim([ 0 0.25])
title("Matlab FFT Fonksiyonu");

data = abs(module);
subplot(3,1,2);
plot(t,data);
xlim([ 0 0.25])
title("VHDL Result");


subplot(3,1,3);
plot(t,x);
title("Sinyal");

