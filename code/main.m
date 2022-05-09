close all
clear
clc

n=32; % length of window
nb=127; % number of windows; must be > 1

%Quantization information
%b=4; % Bits allowed to represent numbers
%L=5; % Quantization interval [-L L]
%q=2*L/(2^b-1); %Quantization number
dataPoints = 4096;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MDCT matrix formation
for i=1:n 
    for j=1:2*n
        M(i,j)= cos((i-1+1/2)*(j-1+1/2+n/2)*pi/n);
    end
end
M=sqrt(2/n)*M;
inverseM=M'; % inverse MDCT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Construct the H vector
h = [];
for k=1:2*n
    val = sqrt(2) * sin(((k+0.5)*pi) / (2*n));
    h = [h val];
end
h = h.'; %Transpose h matrix to make multiplication work

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input data
frequencies = [9,11];  %Multiples of 64
frequencyMatrix = [];
for index=1:size(frequencies,2) %four tones
    x=cos((1:dataPoints)*pi*64*(frequencies(index))/dataPoints); % test signal
    frequencyMatrix = [frequencyMatrix x];
end

combinedOutputs = [];
bFD=[];
for i=1:size(frequencies,2)
    out=[];
    for k=1:nb % loop over windows
        
        %Compression
        tone = frequencyMatrix(((dataPoints*i)-dataPoints+1):dataPoints*i);
        x0=tone(1+(k-1)*n:2*n+(k-1)*n)';            %Get input vector window (Cutting input into windows)
        x0 = x0.*h;                                 %Transform input vector via H-element wise multiplication
        y0=M*x0;                                    %MDCT matrix multiplication to get output vector
        q =[];
        y1=[];
        for j=1:size(y0)
            b =  ceil(abs(log(abs(y0(j))))) + 1;    %Get b bits for the given y value (importance sampling)
            bFD=[bFD; b];
            L = abs(y0(j));                         %Quantization interval [-L L]
            q = [q; 2*L/(2^b-1)];                   %Quantization number
        end
        for f=1:size(q)
            y1=[y1; round(y0(f)/q(f))];             %Quantization
            
        end
        %Decompression
        y2=y1.*q;                                   %Dequantization

        %W is matrix of all windows
        w(:,k)=inverseM*y2;                         %Set column vectors of W to Inverse M * dequantized output vector
        w(:,k)= w(:,k).*h;                          %Undo window function - Multiply new column vector by H element wise

        %Skip first iteration
        if(k>1)
            w2=w(1:n,k);                            %Window split bottom half
            w3=w(n+1:2*n,k-1);                      %Window split top half

            %W2 and W3 are 32x1 column vectors
            out=[out;(w2+w3)/2];                    %Reconstructed signal
        end
    end
    combinedOutputs = [combinedOutputs; out];
end
disp(max(bFD));
bits = sum(bFD);
%Display plots
figure(1);
plot(frequencyMatrix(1:1:end));
hold on 
plot(frequencyMatrix(1:1:end), 'o');
title('Input Data With f = 11');
legend('Input Data Points','Fitted wave')
xlim([0,300]);

figure(2);
plot(combinedOutputs(1:1:end));
hold on
plot(combinedOutputs(1:1:end), 'o');
title('Output With f = 11');
legend('Reconstructed data points','Fitted wave from points')
xlim([0,300]);

Fs=8192; %Sampling rate in (htz?)
%sound(frequencyMatrix,Fs) % Matlab’s sound command
%pause(1)
%sound(combinedOutputs, Fs)
%sound(out,Fs) % play the reconstructed tone