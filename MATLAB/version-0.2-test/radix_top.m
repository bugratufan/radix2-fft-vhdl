clc
clear all
close all

t = 0:1/32:0.49;

ref = zeros(1,80);
func = zeros(1,80);

for a = 0.1:0.1:8
    x = sin(2*pi*t*a);
    res = fft16(x);
    magx = abs(res) .* filter';
    data = abs(fft(x)) .* filter;
    ref(round(a*10),1) = max(data);
    func(round(a*10),1) = max(magx);
    
end
figure,
plot(ref,func);
xlabel("MATLAB referans");
ylabel("RADIX-2 Methodu");
figure,

x = sin(2*pi*t*5) + sin(2*pi*t*2);
res = fft16(x);
magx = abs(res);
subplot(3,1,1);
plot(t,magx);
xlim([ 0 0.25])
title("Radix-2 Methodu");

data = abs(fft(x));
subplot(3,1,2);
plot(t,data);
xlim([ 0 0.25])
title("Matlab FFT Fonksiyonu");


subplot(3,1,3);
plot(t,x);
title("Sinyal");