# A-Single-Path-Delay-32-Point-FFT-Processor
This is a 32-point pipelined Fast Fourier Transform processor, using single path delay architecture.  
The design is based on radix2-DIF(decimation-in-frequency) algorithm. The average SNR = 58.76. 
There are also gate level files (FFT_SYN.v, FFT_SYN.sdf) and python simulation.

## Usage
To run the FFT processor, execute run.f in the src folder.  
Note that you will need ncverilog to do so.

## Block Diagram
![Design](https://github.com/jasonlin316/A-Single-Path-Delay-32-Point-FFT-Processor/blob/master/pic/design.png)

**DELAY MODULE**  
The delay module is simply a FIFO shift register. It will shift 24 bits every cycle. For delay 16, the shift register size is 16x24 = 384.  

**RADIX-2 BUTTERFLY**  
While entering the first radix-2 butterfly, din is extended to 24bits to match the twiddle factor. The radix-2 butterfly is the core processor of this circuit. It contains three states :  
1. Waiting: In waiting state, we cannot do any calculation. For instance, we have to wait for x[16] in the first state to do x[0]+x[16], so x[0]~x[15] will be in waiting state.
2. First Half: In the first half, the output will be the summation of two index, e.g. x[0]+x[16]. We will output x[0]-x[16] to delay module simultaneously.
3. Second Half: In the last state, we multiply the delay signal, which is the signal we output to the delay module in the first half state, with our twiddle factor. Same as above, the input (din_a_r and din_b_r) will be output to the delay module. The complex number multiplication is transformed from 4 multiplication and 2 summation to 3 multiplication 5 summation.    

**ROM AND STATE CONTROL MODULE**  
The ROM is where the twiddle factors are stored. When it receives the valid signal from the front stage, it sets a counter. Based on the counter, it will output a state control output signal to the radix2 butterfly module. For the second half state where multiplication takes place, it will provide the needed twiddle factor.  

**SORT MODULE**  
Since we know the output signal order, we can simply control the order by directing the signal to a 2D array and place the value in the right place. For instance, the 2nd output is X[15], we can store it into result[15]. It will take 32 cycles to sort. To add on, the input of sort module is the most significant 16 bits of the output of the last radix-2 butterfly.

## Design Specification
|   Spec   | Value    |
|-----------|---|
| Frequency | 100MHz  |
| Chip size |   486696.98 µm^2  |
|  Power    |  10.77 mW |
|  Techonlogy | UMC 180nm |

## Background
This is originally a course project of Digital Signal Processing in VLSI Design at National Taiwan University,  
lectured by Prof. [Chia-Hsiang Yang](http://cc.ee.ntu.edu.tw/~dcslab/faculty.html#)  
