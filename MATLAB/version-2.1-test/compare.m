clc;
clear all;
close all;

t = 0:1/32:0.49;

fid = fopen('C:\Users\bugra\Desktop\Yonga\FFT\VHDL\version-2.1\output_results.txt');
vhdl_out = zeros(16,1);

for b = 1:8
    for a = 0:15
        line_ex = fgetl(fid);  % read line excluding newline character
        hex_str = dec2hex(bin2dec(line_ex));
        real_part = typecast(uint32(hex2dec(hex_str)),'single');

        line_ex = fgetl(fid);  % read line excluding newline character
        hex_str = dec2hex(bin2dec(line_ex));
        imag_part = typecast(uint32(hex2dec(hex_str)),'single');

        vhdl_out(a+1,b) = complex(real_part,imag_part);
    end
end 

module = zeros(16,5);

%reorder
for b = 1:8
    module(1,b) = vhdl_out(1,b);
    module(2,b) = vhdl_out(9,b);
    module(3,b) = vhdl_out(5,b);
    module(4,b) = vhdl_out(13,b);
    module(5,b) = vhdl_out(3,b);
    module(6,b) = vhdl_out(11,b);
    module(7,b) = vhdl_out(7,b);
    module(8,b) = vhdl_out(15,b);
    module(9,b) = vhdl_out(2,b);
    module(10,b) = vhdl_out(10,b);
    module(11,b) = vhdl_out(6,b);
    module(12,b) = vhdl_out(14,b);
    module(13,b) = vhdl_out(4,b);
    module(14,b) = vhdl_out(12,b);
    module(15,b) = vhdl_out(8,b);
    module(16,b) = vhdl_out(16,b);
end

figure,
% 
% for c = 1:5
%     x = sin(2*pi*t*2*c) + 2*sin(2*pi*t*c);
%     data = abs(fft(x));
%     subplot(8,1,c);
%     plot(t,data);
%     xlim([ 0 0.25])
%     title("Model "+num2str(c));
% end
for c = 1:8
    x = sin(2*pi*t*c);
    data = abs(fft(x));
    subplot(8,1,c);
    plot(t.*64,data);
    xlim([ 0 0.25*64])
    title("Model "+num2str(c));
end

%% Model Result
figure,

for b=1:8

data = abs(module(1:16,b));
subplot(8,1,b);
plot(t.*64,data);
xlim([ 0 0.25*64])
title("VHDL Result " + num2str(b));

end

