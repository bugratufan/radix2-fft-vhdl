Ayrık zamanlı Fourier dönüşümü (DFT), ayrık zamanlı sinyal işleme algoritma ve sistemlerinin analizi, tasarımı, gerçekleştirilmesi ile doğrusal filtreleme, korelasyon analizi ve spektrum analizi gibi sinyal işleme uygulamalarında önemli bir rol oynar. DFT’nin bu öneme sahip olmasının ardındaki temel neden DFT’yi hesaplamakta kullanılan verimli algoritmaların varlığıdır.

Bu projede giriş sinyalinin DFT’sini hesaplamak için FFT algoritması kullanılmıştır. FFT tekrarlanmayan sinyalleri dikkate almaz ve karmaşık sinyaller içinde periyodik olanları belirleyip harmonik bileşenlerine ayırır.

Bu proje kapsamında oluşturulan RADIX2 Modülü ile 16 noktalı örnekleme yaparak fast fourier transform işleminin gerçeklenmesi amaçlanmıştır. FFT hesaplamalarında Radix-2 FFT methodu kullanılmıştır[1].

Sistemin her biri 32 bitten oluşan IEEE-754 standardında 16 adet girdisi bulunmaktadır. Bu girdilere örneklenen sinyal değerinin girilmesi gerekmektedir.
FFT işleminin sonuçları IEEE-754 32bit standardında çıkmaktadır. 32 adet çıktı bulunmaktadır. Kompleks sayılar, kompleks kısım için ve reel kısım için ayrı olmak üzere 2 adet IEEE-754 32bit standardında çıktı olarak verilmektedir.

BEKLENİLEN HATALI SONUÇLAR
Sonucun 0 olduğu bazı durumlarda sıfıra çok yakın sonuçlar verebilmektedir.

KAYNAKLAR
 ALINTILAR
[1] Ze-ke Wang, Xue Liu, “A combined SDC-SDF architecture for normal I/O pipelined radix-2 FFT”, IEEE Transactions on Very Large Scale Integration (VLSI) Systems, May 2014.

Tasarımda kullanılan IEEE-754 çarpma modülü: https://www.edaboard.com/showthread.php?52628-FLOATING-POINT-MULTIPLICATION-USING-VHDL

 FAYDALI MAKALE VE LİNKLER
 
Nandyala Ramanatha Reddy, Lyla B. Das, A.Rajesh, Sriharsha Enjapuri, Dept. of Electronics and Communication, NIT Calicut, Calicut, India, “ASIC Implementation of High speed Fast Fourier Transform Based on Split-Radix algorithm”, International Conference on Embedded Systems, 2014
754-2008 - IEEE Standard for Floating-Point Arithmetic - IEEE Standard. [online] Available at: https://ieeexplore.ieee.org/document/4610935.
