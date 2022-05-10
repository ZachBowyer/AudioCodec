function [audioBits,y1] = coder(vectorX)
    n=32; % length of window
    nb=127; % number of windows; must be > 1
    dataPoints = 4096;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MDCT matrix formation
    for i=1:n 
        for j=1:2*n
            M(i,j)= cos((i-1+1/2)*(j-1+1/2+n/2)*pi/n);
        end
    end
    M=sqrt(2/n)*M;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Construct the H vector
    h = [];
    for k=1:2*n
        val = sqrt(2) * sin(((k+0.5)*pi) / (2*n));
        h = [h val];
    end
    h = h.'; %Transpose h matrix to make multiplication work

   bFD = [];
   for k=1:nb % loop over windows
        %Compression
        tone = vectorX(((dataPoints*i)-dataPoints+1):dataPoints*i);
        x0=tone(1+(k-1)*n:2*n+(k-1)*n)';            %Get input vector window (Cutting input into windows)
        x0 = x0.*h;                                 %Transform input vector via H-element wise multiplication
        y0=M*x0;                                    %MDCT matrix multiplication to get output vector
        q =[];
        for j=1:size(y0)
            b =  ceil(abs(log(abs(y0(j))))) + 1;    %Get b bits for the given y value (importance sampling)
            bFD=[bFD; b];
            L = abs(y0(j));                         %Quantization interval [-L L]
            q = [q; 2*L/(2^b-1)];                   %Quantization number
        end
        for f=1:size(q)
            y1=[y1; round(y0(f)/q(f))];             %Quantization
        end
   end
   audioBits=max(bFD);

end

