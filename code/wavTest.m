close all
clear 
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=128; % length of window
nb=2032; % number of windows; must be > 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 2
[newX,FS] = audioread('./audio/audio(1).wav');
newX = [newX(:,1)]';

[q, y1] = coder(newX, n, nb);
out = decoder(y1, q, n, nb);
%[pxx,frequencies] = pwelch(newX,[],[],[],FS);
s = whos('newX');
disp(s.bytes);
%sound(newX,FS);
%pause(5)
sound(out, FS);