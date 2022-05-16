close all
clear 
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=128; % length of window
nb=2031; % number of windows; must be > 1
%nb=10160; % number of windows; must be > 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 2
%Read file data to get data
fileName = 'audio(1).wav';                          %File name
[newX,FS] = audioread(['./audio/', fileName]);      %Use audio read to sampling rate and wave
combinedOut = [];                                   %pre-assign out variable
[numwRows, numCols]=size(newX);                     %Get number of rows and cols

%%%%%
%Get total bits for precompressed audio
s = whos('newX');                                   
disp('Old file data');
disp(s.bytes);

%%%%%
%Summing the different channels as one vector
%test = (newX(:,1)+newX(:,2))/2;
%[q, y1] = coder(test, n, nb);
%out = decoder(y1, q, n, nb);

%%%%%
%encoding and decoding each channel seperatetly
for i=1:numCols
    xRow = newX(:,i)';
    [q, y1] = coder(xRow, n, nb);
    out = decoder(y1, q, n, nb);
   combinedOut = [combinedOut out];
end
%%%%%
%To play the varibles directly
%sound(newX,FS);
%pause(100)
%sound(combinedOut, FS);

%%%%%
%To write the audio to a file
newFileName = ['reconstructed-' fileName];
audiowrite(['reconstructed-' newFileName],combinedOut, FS);
%audiowrite(['reconstructed-' newFileName],out, FS);

%%%%%
%To display the total bits for the uncompressed audio
o = whos('combinedOut');
%o = whos('out');
disp("New file data");
disp(o.bytes);