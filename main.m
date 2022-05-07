close all
clear
clc

n=32; % length of window
nb=127; % number of windows; must be > 1

%Quantization information
b=100; % Bits allowed to represent numbers
L=5; % Quantization interval [-L L]
q=2*L/(2^b-1); %Quantization number

%MDCT matrix formation
for i=1:n 
    for j=1:2*n
        M(i,j)= cos((i-1+1/2)*(j-1+1/2+n/2)*pi/n);
    end
end
M=sqrt(2/n)*M;
inverseM=M'; % inverse MDCT

Fs=8192; %Sampling rate in (htz?)

%Input data
f=4;  %frequency
x=cos((1:4096)*pi*64*f/4096); % test signal

%Construct the H vector
h = [];
for k=1:2*n
    val = sqrt(2) * sin(((k+0.5)*pi) / (2*n));
    h = [h val];
end
h = h.'; %Transpose h matrix to make multiplication work


out=[];
for k=1:nb % loop over windows
    
    %Compression
    x0=x(1+(k-1)*n:2*n+(k-1)*n)';       %Get input vector window (Cutting input into windows)
    x0 = x0.*h;                         %Transform input vector via H-element wise multiplication
    y0=M*x0;                            %MDCT matrix multiplication to get output vector
    y1=round(y0/q);                     %Quantization
    
    %Decompression
    y2=y1*q;                            %Dequantization
    
    %W is matrix of all windows
    w(:,k)=inverseM*y2;                 %Set column vectors of W to Inverse M * dequantized output vector
    w(:,k)= w(:,k).*h;                  %Undo window function - Multiply new column vector by H element wise
    
    %Skip first iteration
    if(k>1)
        w2=w(1:n,k);                    %Window split bottom half
        w3=w(n+1:2*n,k-1);              %Window split top half

        %W2 and W3 are 32x1 column vectors
        out=[out;(w2+w3)/2];            %Reconstructed signal
    end
end

%Display plots
figure(1);
plot(x);
hold on 
plot(x, 'o');
title('Input Data With Even f');
legend('Input Data Points','Fitted wave')
xlim([0,1000]);

figure(2);
plot(out);
hold on
plot(out, 'o');
title('Output With Even f');
legend('Reconstructed data points','Fitted wave from points')
xlim([0,100]);

Fs=8192; %Sampling rate in (htz?)
sound(x,Fs) % Matlab’s sound command
pause(1)
sound(out,Fs) % play the reconstructed tone