function [out] = decoder(y1)
    n=32; % length of window
    nb=127; % number of windows; must be > 1

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
    for k=1:nb
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
end

