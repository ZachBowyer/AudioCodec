close all
clear 
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=128; % length of window
nb=2031; % number of windows; must be > 1
%nb=10160; % number of windows; must be > 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 2
fileName = 'audio(1).wav';
[newX,FS] = audioread(['./audio/', fileName]);
combinedOut = [];
[numwRows, numCols]=size(newX);
s = whos('newX');
disp('Old file data');
disp(s.bytes);
%%%%%
%Summing the different channels as one vector
%test = (newX(:,1)+newX(:,2))/2;
%[q, y1] = coder(test, n, nb);
%out = decoder(y1, q, n, nb);
for i=1:numCols
    xRow = newX(:,i)';
    [q, y1] = coder(xRow, n, nb);
    out = decoder(y1, q, n, nb);
   combinedOut = [combinedOut out];
end
%[pxx,frequencies] = pwelch(newX,[],[],[],FS)
%sound(newX,FS);
%pause(100)
%sound(combinedOut, FS);
newFileName = ['reconstructed-' fileName];
audiowrite(['reconstructed-' newFileName],combinedOut, FS);
%audiowrite(['reconstructed-' newFileName],out, FS);
o = whos('combinedOut');
%o = whos('out');
disp("New file data");
disp(o.bytes);