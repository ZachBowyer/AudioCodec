close all
clear 
clc

n=32; % length of window
nb=127; % number of windows; must be > 1
Fs=8192; %Sampling rate in (htz?)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input data
frequencies = [10];  %Multiples of 64
frequencyMatrix = [];
for index=1:size(frequencies,2) %four tones
    x=cos((1:Fs)*pi*64*(frequencies(index))/Fs); % test signal
    frequencyMatrix = [frequencyMatrix x];
end
combinedOut = [];
for i=1:size(frequencies,2)
    %Calling for coder/decoder
    %Input: a vector of numbers (in a wave format (cos()))
    %Output: q vector containing the quantization numbers for the compressed output of
    %the coder, y1 is the compressed output of the coder
    tone = frequencyMatrix(((Fs*i)-dataPoints+1):Fs*i);
    [q, y1] = coder(tone, n, nb);
    %Input: compressed data vector (y1) from a coder, quantization numbers (q) for
    %the y1 vector
    %Output: reconstructed data vector (out) of the given compressed vector and its
    %quantization numbers
    out = decoder(y1, q, n, nb);
    combinedOut = [combinedOut; out];
    s = whos('tone');
    disp(s.bytes*8);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display plots
figure(1);
plot(frequencyMatrix(1:1:end));
hold on 
plot(frequencyMatrix(1:1:end), 'o');
title('Input Data With f = 11');
legend('Input Data Points','Fitted wave')
xlim([0,300]);

figure(2);
plot(combinedOut(1:1:end));
hold on
plot(combinedOut(1:1:end), 'o');
title('Output With f = 11');
legend('Reconstructed data points','Fitted wave from points')
xlim([0,300]);

Fs=8192; %Sampling rate in (htz?)
sound(frequencyMatrix,Fs) % Matlab�s sound command
pause(3)
sound(combinedOut, Fs)
%sound(out,Fs) % play the reconstructed tone