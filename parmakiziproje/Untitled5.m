clc,clear,close all
load database person minutiae

temp=minutiae;
   %minu1 = num2cell(minu1);
    %minu1 = struct('ID', id1, 'X', string_data(:, 1), 'Y', string_data(:, 2),...
      %            'Type', string_data(:, 3), 'Angle', string_data(:, 4), ...
                   %'S1', string_data(:, 5), 'S2', string_data(:, 6));
               
 [m,n]=size(temp);
for i=1:m
gecici= convertStringsToChars(temp.X{i,1});
gecici=str2num(cell2mat(gecici));
id1=(temp(i,1));


[p,k]=size(gecici);
for i=1:p
    for j=1:k
    cozum(1,j)=gecici(i,j);
    end
    dcozum=reshape(cozum,2,2).';
    bdecrypt=decrypt(dcozum,5,'araba');
 
    sifre(i,1)=str2num(bdecrypt);
   % cdecrypt = struct('ID', id1, 'X',sifre);
end
sifre=num2cell(sifre);
cdecrypt = struct('ID', id1, 'X',sifre);

end

     


%a=(reshape(a,2,2)).'
%c=decrypt(a,5,'araba')
     %end
% end
 
        
     
       
        




