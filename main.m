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
N=M'; % inverse MDCT

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
    x0=x(1+(k-1)*n:2*n+(k-1)*n)';
    
    %Transform input vector via H-element wise multiplication
    x0 = x0.*h;
    y0=M*x0;
    
    y1=round(y0/q); % transform components quantized
    y2=y1*q; % and dequantized
    w(:,k)=N*y2.*h; % invert the MDCT
    %w(:,k)=N*y2;
    disp(size(w))
    if(k>1)
        w2=w(n+1:2*n,k-1);
        w3=w(1:n,k);
        out=[out;(w2+w3)/2]; % collect the reconstructed signal
    end
end
%disp(size(out));

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