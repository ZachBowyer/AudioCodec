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
for i=1:numCols
    xRow = newX(:,i)';
    [q, y1] = coder(xRow, n, nb);
    out = decoder(y1, q, n, nb);
    combinedOut = [combinedOut out];
end
%[pxx,frequencies] = pwelch(newX,[],[],[],FS);
s = whos('newX');
disp('Old file data');
disp(s.bytes);
%sound(newX,FS);
%pause(100)
%sound(combinedOut, FS);
newFileName = ['reconstructed-' fileName];
audiowrite(['./audio/' newFileName],combinedOut, FS);
o = whos('combinedOut');
disp("New file data");
disp(o.bytes);