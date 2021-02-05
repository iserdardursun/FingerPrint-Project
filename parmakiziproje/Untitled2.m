clc,clear,close all
a=[1200 1000 1200 ];

sz = size(a);




    output_data = a;
%     if (sz(2)>sz(1)
        
        mm = 2;
        sz = size(output_data);
        rem = sz(2);
        while(rem/mm > mm) %DETERMINES BEST N-SIZE MATRIX
            mm = mm+1;
        end
        
%         while (mod(sz(2),mm) ~= 0)
%             input_data(1:output
        for (ii=1:inf) %DETERMINES M-SIZE FROM N-SIZE
            if((mm*ii) < sz(2)) 
                ii= ii+1;
            else
                break
            end
        end
        output_data
        output_data(1,rem+1:(mm*mm)) = 124; %FILLER DATA = |
            
        output_data = reshape(output_data,[mm,mm]);
        disp(output_data)
