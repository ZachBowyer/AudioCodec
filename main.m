close all
clear
clc

n=32; % length of window
nb=127; % number of windows; must be > 1
b=4; L=5; % quantization information
q=2*L/(2^b-1); % b bits on interval [-L, L]

for i=1:n % form the MDCT matrix
    for j=1:2*n
        M(i,j)= cos((i-1+1/2)*(j-1+1/2+n/2)*pi/n);
    end
end

s1 = cos((1:10))
s2 = cos((1:10)*2)
disp(s1, s2)
%size(s2)
%sampleRate = 4096;
%sound(s2, sampleRate);
%disp(s2);

M=sqrt(2/n)*M;
N=M'; % inverse MDCT
Fs=8192; % Sampleing rate in (htz?)
f=11;  %???
x=cos((1:8192)*pi*64*f/4096); % test signal
disp(x)
sound(x,Fs) % Matlab�s sound command

out=[];
for k=1:nb % loop over windows
    x0=x(1+(k-1)*n:2*n+(k-1)*n)';
    y0=M*x0;
    y1=round(y0/q); % transform components quantized
    y2=y1*q; % and dequantized
    w(:,k)=N*y2; % invert the MDCT
    if(k>1)
    w2=w(n+1:2*n,k-1);w3=w(1:n,k);
    out=[out;(w2+w3)/2]; % collect the reconstructed signal
    end
end
pause(1)
%sound(out,Fs) % play the reconstructed tone