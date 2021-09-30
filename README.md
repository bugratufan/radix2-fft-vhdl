<h2>Radix-2 FFT - VHDL Implementation</h2>

Discrete-time Fourier transform (DFT) plays an important role in the analysis, design, and implementation of discrete-time signal processing algorithms and systems, and in signal processing applications such as linear filtering, correlation analysis, and spectrum analysis. The main reason behind DFT's importance is the existence of efficient algorithms used to calculate DFT.

In this project, the FFT algorithm is used to calculate the DFT of the input signal. FFT ignores non-repeating signals and determines periodic ones among complex signals and separates them into harmonic components.

With the RADIX2 Module created within the scope of this project, it is aimed to perform the fast fourier transform process by making 16-point sampling. Radix-2 FFT method was used in FFT calculations[1].

The system has 16 inputs in the IEEE-754 standard, each of which consists of 32 bits. The sampled signal value must be entered into these inputs. The results of the FFT process come out in the IEEE-754 32bit standard. Complex numbers are output as 2 pieces of IEEE-754 32bit standard, one for the complex part and one for the real part.

<h3>EXPECTED INCORRECT RESULTS</h3> 
**In some cases where the result is 0, it can give results very close to zero.**


<h3>REFERENCES</h3>
[1] Ze-ke Wang, Xue Liu, “A combined SDC-SDF architecture for normal I/O pipelined radix-2 FFT”, IEEE Transactions on Very Large Scale Integration (VLSI) Systems, May 2014.

This IEEE-754 multiplication module used in the design: https://www.edaboard.com/showthread.php?52628-FLOATING-POINT-MULTIPLICATION-USING-VHDL

<h3>USEFUL ARTICLES AND LINKS</h3>
Nandyala Ramanatha Reddy, Lyla B. Das, A.Rajesh, Sriharsha Enjapuri, Dept. of Electronics and Communication, NIT Calicut, Calicut, India, “ASIC Implementation of High speed Fast Fourier Transform Based on Split-Radix algorithm”, International Conference on Embedded Systems, 2014

754-2008 - IEEE Standard for Floating-Point Arithmetic - IEEE Standard. [online] Available at: https://ieeexplore.ieee.org/document/4610935.

https://www.beechwood.eu/fft-implementation-r2-dit-r4-dif-r8-dif/

https://www.algorithm-archive.org/contents/cooley_tukey/cooley_tukey.html
